# frozen_string_literal: true

require 'rails_helper'
require 'digest'

RSpec.describe Crypto::Hmac::Sign, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { payload: payload } }
    let(:payload) { { "username" => "john_doe", "password" => "secret123" } }
    let(:secret_key) { "secret" }
    let(:signed_payload) { "+/Qkp2DE+6BJK246tPZnv1sPrY+tDsmHweRbQ4t2lm6k=" }
    before do
      allow(ENV).to receive(:fetch).with("HMAC_SECRET_KEY").and_return(secret_key)
      allow(OpenSSL::HMAC).to receive(:digest).and_return("Signature")
      allow(Base64).to receive(:encode64).and_return("Base64EncodedSignature")
    end

    context "when inputs are valid" do
      it "is valid" do
        expect(outcome).to be_valid
      end

      it "returns a hash with SHA256 Base64 encoded values" do
        expect(outcome.result).to eq("Base64EncodedSignature")
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
