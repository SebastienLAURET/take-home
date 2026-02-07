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
       @signature ||= OpenSSL::HMAC.digest(
                "SHA256",
                secret_key.unpack1("H*"),
                payload.to_json_c14n
            ).unpack1("H*")
    end
end
