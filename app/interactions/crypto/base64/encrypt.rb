# frozen_string_literal: true

class Crypto::Base64::Encrypt < ApplicationInteraction
    hash :payload, strip: false, required: true

    def execute
        encrypted_payload
    end

    private

    def encrypted_payload
        @encrypted_payload ||= payload.transform_values { |value| Base64.encode64(value.to_json) }
    end
end
