# frozen_string_literal: true

class Crypto::Verify < ApplicationInteraction
  # Reloading class to fix constant reference
  CRYPTO_VERIFY_ALGORITHMS = {
    hmac: Crypto::Hmac::Verify
  }.freeze

  hash :data, strip: false, required: true
  string :signature, required: true
  symbol :algorithm, default: :hmac

  validates_inclusion_of :algorithm, in: CRYPTO_VERIFY_ALGORITHMS.keys

  def execute
    check_signature
  end

  private

  def check_signature
    @check_signature ||= compose(verify_interaction, data: data, signature: signature)
  end

  def verify_interaction
    CRYPTO_VERIFY_ALGORITHMS[algorithm]
  end
end
