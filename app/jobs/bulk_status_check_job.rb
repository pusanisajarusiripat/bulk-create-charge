class BulkStatusCheckJob
  include Sidekiq::Worker

  def perform(bulk_id)
    bulk = Bulk.find(bulk_id)
    completed = bulk.charges.where(status: :completed).count
    failed = bulk.charges.where(status: :failed).count
    total = bulk.amount_of_charges

    if completed == total
      bulk.update!(status: :finished)
    elsif failed > 0 || (completed + failed == total)
      bulk.update!(status: :finished_with_error)
    else
      bulk.update!(status: :in_process)
      # Schedule another check in 5 seconds
      BulkStatusCheckJob.perform_in(5.seconds, bulk_id)
    end
  end
end
