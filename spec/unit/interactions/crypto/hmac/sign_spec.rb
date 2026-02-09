# frozen_string_literal: true

require 'rails_helper'
require 'digest'

RSpec.describe Crypto::Hmac::Sign, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { payload: payload, secret_key: secret_key } }
    let(:payload) { { "username" => "john_doe", "password" => "secret123" } }
    let(:secret_key) { "secret_key" }
    let(:signature) { double("Signature", unpack1: signature_hex) }
    let(:signature_hex) { "Signaturehex" }
    let(:secret_key_bytes) { "secret_key_bytes" }

    before do
      allow(OpenSSL::HMAC).to receive(:digest).and_return(signature)
      allow_any_instance_of(Array).to receive(:pack).and_return(secret_key_bytes)
    end

    context "when inputs are valid" do
      it "is valid" do
        expect(outcome).to be_valid
      end

      it "calls OpenSSL::HMAC#digest" do
        expect(OpenSSL::HMAC).to receive(:digest).with("SHA256", secret_key_bytes, payload.to_json_c14n)
        outcome
      end

      it "returns a hash with SHA256 Base64 encoded values" do
        expect(outcome.result).to eq(signature_hex)
      end
    end

    context "when payload is not provided" do
      let(:inputs) { {} }

      it "is invalid" do
        expect(outcome).to be_invalid_with(:payload, :missing)
      end
    end

    context "when payload is not a hash" do
      let(:inputs) { { payload: "not a hash" } }

      it "is invalid" do
        expect(outcome).to be_invalid_with(:payload, :invalid_type)
      end
    end
  end
end
