# frozen_string_literal: true

class Crypto::Encrypt < ApplicationInteraction
    CRYPTO_ENCRYPT_ALGORITHMS = {
        base64: Crypto::Base64::Encrypt
    }

    hash :payload, strip: false, required: true
    symbol :algorithm, default: :base64

    validates_inclusion_of :algorithm, in: CRYPTO_ENCRYPT_ALGORITHMS.keys


    def execute
        encrypted_payload
    end

    private

    def encrypted_payload
        @encrypted_payload ||= compose(encrypt_interaction, payload: payload)
    end

    def encrypt_interaction
        CRYPTO_ENCRYPT_ALGORITHMS[algorithm]
    end
end
