# frozen_string_literal: true

class Crypto::Verify < ApplicationInteraction
  # Reloading class to fix constant reference
  CRYPTO_VERIFY_ALGORITHMS = {
    hmac: Crypto::Hmac::Verify
  }

  hash :payload, strip: false, required: true
  string :signature, required: true
  symbol :algorithm, default: :hmac

  validates_inclusion_of :algorithm, in: CRYPTO_VERIFY_ALGORITHMS.keys

  def execute
    {
      valid: signature_valid?
    }
  end

  private

  def signature_valid?
    @signature_valid ||= compose(verify_interaction, payload: payload, signature: signature)
  end

  def verify_interaction
    CRYPTO_VERIFY_ALGORITHMS[algorithm]
  end
end
