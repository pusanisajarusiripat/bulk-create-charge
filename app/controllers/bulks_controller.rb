class BulksController < ApplicationController
  http_basic_authenticate_with name: ENV["BULK_AUTH_USER"], password: ENV["BULK_AUTH_PASSWORD"]

  def index
    @bulks = Bulk.all
  end

  def show
    @bulk = Bulk.find(params[:id])
  end

  def new
    @bulk = Bulk.new
  end

  def create
    uploaded_file = params[:bulk][:file]
    @bulk = Bulk.new

    if !validate_uploaded_file(uploaded_file, @bulk)
      render :new and return
    end

    if @bulk.save
        @bulk.file.attach(uploaded_file)
        row_count = @bulk.file.blob.open { |file| file.each_line.count }
        puts "row count: #{row_count}"
        if row_count > 500
          @bulk.errors.add(:file, "cannot have more than 500 rows")
          @bulk.file.purge
          return render :new, status: :unprocessable_entity
        end

        # create charges
        Charge.create_from_csv(@bulk.file, @bulk)
        # render charges.import, starting the import process

        @bulk.update(amount_of_charges: row_count)
        # starting bg process
        redirect_to @bulk, notice: "Bulk import initiated. Processing will start shortly."
    else
      render :new
    end
  end

  def destroy
    @bulk = Bulk.find(params[:id])
    if @bulk.destroy
      redirect_to bulk_path, notice: "Bulk import deleted successfully."
    else
      redirect_to bulk_path, alert: "Failed to delete bulk import."
    end
  end


  private
    def bulk_params
      params.require(:bulk).permit(:file)
    end

    def validate_uploaded_file(uploaded_file, bulk)
      if uploaded_file.nil?
        bulk.errors.add(:file, "must be uploaded")
        return false
      end

      unless ["text/csv", "application/csv", "text/plain"].include?(uploaded_file.content_type)
        bulk.errors.add(:file, "must be a CSV file (e.g., .csv extension, or content type 'text/csv')")
        return false
      end

      unless File.extname(uploaded_file.original_filename).downcase == ".csv"
        bulk.errors.add(:file, "must have a .csv extension")
        return false
      end

      true
    end
end
