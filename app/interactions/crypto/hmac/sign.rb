# frozen_string_literal: true

require "digest"

class Crypto::Hmac::Sign < ApplicationInteraction
    hash :payload, strip: false, required: true
    string :secret_key, default: ENV.fetch("HMAC_SECRET_KEY")

    def execute
        signature
    end

    private

    def signature
       @signature ||= Base64.encode64(
            OpenSSL::HMAC.digest(
                "SHA256",
                secret_key,
                payload.to_json_c14n
            )
       )
    end
end
