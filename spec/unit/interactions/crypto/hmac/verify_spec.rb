# frozen_string_literal: true

require "rails_helper"
require "digest"

RSpec.describe Crypto::Hmac::Verify, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { data: data, signature: signature, secret_key: secret_key } }
    let(:data) { { "username" => "john_doe", "password" => "secret123" } }
    let(:secret_key) { "SecretKey" }
    let(:signature) { "signature" }
    let(:calculated_signature) { "calculated_signature" }



    context "when inputs are valid and signature matches" do
      before do
        allow(OpenSSL::HMAC).to receive(:digest).and_return(calculated_signature)
        allow(ActiveSupport::SecurityUtils).to receive(:secure_compare).and_return(true)
        allow_any_instance_of(Array).to receive(:pack).and_return("bytes_value")
      end

      it "is valid" do
        expect(outcome).to be_valid
      end

      it "calls OpenSSL::HMAC#digest" do
        expect(OpenSSL::HMAC).to receive(:digest).with("SHA256", "bytes_value", data.to_json_c14n)
        outcome
      end

      it "calls ActiveSupport::SecurityUtils#secure_compare" do
        expect(ActiveSupport::SecurityUtils).to receive(:secure_compare).with("bytes_value", calculated_signature)
        outcome
      end

      it "returns true" do
        expect(outcome.result).to be true
      end
    end

    context "when signature does not match" do
      let(:signature) { "InvalidSignature" }

      it "is invalid" do
        expect(outcome).to be_invalid
        expect(outcome.errors[:signature]).to include("is invalid")
      end
    end

    context "when data is not provided" do
      let(:inputs) { { signature: signature } }

      it "is invalid" do
        expect(outcome).to be_invalid
        expect(outcome.errors[:data]).to include("is required")
      end
    end

    context "when signature is not provided" do
      let(:inputs) { { data: data } }

      it "is invalid" do
        expect(outcome).to be_invalid
        expect(outcome.errors[:signature]).to include("is required")
      end
    end
  end
end
