# frozen_string_literal: true

require "digest"

class Crypto::Hmac::Verify < ApplicationInteraction
  hash :payload, strip: false, required: true
  string :signature, required: true
  string :secret_key, default: ENV.fetch("HMAC_SECRET_KEY")

  def execute
    signature_valid?
  end

  private

  def signature_valid?
    ActiveSupport::SecurityUtils.secure_compare(
      [ signature ].pack("H*"),
      calculated_signature
    )
  end

  def calculated_signature
      OpenSSL::HMAC.digest(
        "SHA256",
        secret_key.unpack1("H*"),
        payload.to_json_c14n
      )
  end
end
