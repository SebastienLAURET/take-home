# frozen_string_literal: true

class Crypto::Base64::Decrypt < ApplicationInteraction
  hash :payload, strip: false, required: true

  def execute
    decrypted_payload
  end

  private

  def decrypted_payload
    @decrypted_payload ||= payload.transform_values do |value|
      JSON.parse(Base64.decode64(value))
    end
  rescue JSON::ParserError, ArgumentError
    errors.add(:base, "Invalid payload")
  end
end
