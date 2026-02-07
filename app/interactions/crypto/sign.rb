# frozen_string_literal: true

class Crypto::Sign < ApplicationInteraction
    # Reloading class to fix constant reference
    CRYPTO_SIGN_ALGORITHMS = {
        hmac: Crypto::Hmac::Sign
    }

    hash :payload, strip: false, required: true
    symbol :algorithm, default: :hmac

    validates_inclusion_of :algorithm, in: CRYPTO_SIGN_ALGORITHMS.keys

    def execute
        {
            signature: signed_payload
        }
    end

    private

    def signed_payload
        @signed_payload ||= compose(sign_interaction, payload: payload)
    end

    def sign_interaction
        CRYPTO_SIGN_ALGORITHMS[algorithm]
    end
end
