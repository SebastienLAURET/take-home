# frozen_string_literal: true

class Crypto::Decrypt < ApplicationInteraction
  CRYPTO_DECRYPT_ALGORITHMS = {
    base64: Crypto::Base64::Decrypt
  }.freeze

  hash :payload, strip: false, required: true
  symbol :algorithm, default: :base64

  validates_inclusion_of :algorithm, in: CRYPTO_DECRYPT_ALGORITHMS.keys
  validates_presence_of :decrypt_interaction

  def execute
    decrypted_payload
  end

  private

  def decrypted_payload
    @decrypted_payload ||= compose(decrypt_interaction, payload: payload)
  end

  def decrypt_interaction
    CRYPTO_DECRYPT_ALGORITHMS[algorithm]
  end
end
