# frozen_string_literal: true

require "digest"

class Crypto::Hmac::Verify < ApplicationInteraction
  hash :data, strip: false, required: true
  string :signature, required: true
  string :secret_key, default: ENV.fetch("HMAC_SECRET_KEY")

  validate :check_signature

  def execute
    true
  end

  private

  def check_signature
    return if signature_valid?

    errors.add(:signature, :invalid)
  end

  def signature_valid?
    ActiveSupport::SecurityUtils.secure_compare(
      [signature].pack("H*"),
      calculated_signature
    )
  end

  def calculated_signature
    OpenSSL::HMAC.digest(
      "SHA256",
      secret_key.unpack1("H*"),
      data.to_json_c14n
    )
  end
end
