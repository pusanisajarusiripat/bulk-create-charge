require "faraday"

class ChargeJob < ApplicationJob
  # each charge will call this to create a charge
  # in this we'll have to call to get the token first
  # assign the token response to the charge
  def perform(charge, charge_id)
    current_charge = Charge.find(charge_id)

    token_response = create_token(charge)
    puts "token_id: #{token_response["id"]}"
    # then we can create the charge with that token
    charge_response = create_charge(token_response["id"], charge)
    puts "paid_at: #{charge_response["paid_at"]}"
    current_charge.update(token_API_response: token_response,
      charge_API_response: charge_response,
      capture_at: charge_response["paid_at"])

    current_charge.update(charge_id: charge_response["id"]) if charge_response["id"].present?

    current_charge.update(status: Charge.statuses[:in_process]) if charge_response["status"] == "in_process"
    current_charge.update(status: Charge.statuses[:pending]) if charge_response["status"] == "pending"
    current_charge.update(status: Charge.statuses[:completed]) if charge_response["status"] == "successful"
    current_charge.update(status: Charge.statuses[:failed]) if charge_response["status"] == "failed"
  end

  def create_token(charge)
    if charge.nil? || charge.empty?
      puts "Charge data is missing or empty. Cannot create token."
      return
    end
    puts "-------------------------------------------"
    puts "Creating token for charge: #{charge.inspect}"
    begin
      card_params = {
        "card[name]":  charge["card_name"].to_s || "JOHN DOE",
        "card[city]": charge["card_city"].to_s || "Bangkok",
        "card[postal_code]": charge["card_postal_code"].to_s || "10320",
        "card[number]": charge["card_number"].to_s || "4242424242424242",
        "card[security_code]": charge["card_security_code"].to_s || "123",
        "card[expiration_month]": charge["card_expiration_month"].to_s || "3",
        "card[expiration_year]": charge["card_expiration_year"].to_s || "2030"
      }

      headers = {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Authorization" => "Basic #{Base64.strict_encode64("#{charge["pkey"] || ENV['P_KEY']}:")}"
      }

      puts "Creating token with params: #{card_params}"
      puts "Using headers: #{headers}"

      response = Faraday.post("#{ENV['VAULT_URL']}/tokens",
        URI.encode_www_form(card_params),
        headers
      )
    rescue => e
      puts "Exception during Vault API call: #{e.class} - #{e.message}"
      puts e.backtrace
    end
    puts "-------------------------------------------"
    puts "Vault API response status: #{response.status}"
    if response.success?
      puts "Token created successfully: #{response.body}"
    else
      puts "Failed to create token: #{response.status} - #{response.body}"
    end
    JSON.parse(response.body)
  end

  def create_charge(token, charge)
    if token.nil? || token.empty?
      puts "Token is missing or empty. Cannot create charge."
      return
    end
    puts "---------------------------------------------------------"
    puts "Creating charge with token: #{token} for charge: #{charge.inspect}"
    begin
      charge_params = {
        "card": token,
        "amount": charge["charge_amount"].to_i,
        "currency": charge["charge_currency"].to_s
      }

      headers = {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Authorization" => "Basic #{Base64.strict_encode64("#{charge["skey"] || ENV['S_KEY']}:")}"
      }

      puts "Creating charge with params: #{charge_params}"
      puts "Using headers: #{headers}"

      response = Faraday.post("#{ENV['URL']}/charges",
      URI.encode_www_form(charge_params),
      headers
      )
    rescue => e
      puts "Exception during Vault API call: #{e.class} - #{e.message}"
      puts e.backtrace
    end
    puts "---------------------------------------------------------"
    puts "Charge API response status: #{response.status}"
    if response.success?
      puts "Charge created successfully: #{response.body}"
    else
      puts "Failed to create charge: #{response.status} - #{response.body}"
    end
    JSON.parse(response.body)
  end
end
