# frozen_string_literal: true

require "rails_helper"
require "digest"

RSpec.describe Crypto::Hmac::Verify, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { data: data, signature: signature, secret_key: secret_key } }
    let(:data) { { "username" => "john_doe", "password" => "secret123" } }
    let(:secret_key) { "95eb51cbac2ee5e96b58d8dc79cde3bd6a5798c3a1673f7b2102679cfb12b023" }
    let(:signature) { "29ca9635908c3a75f3bacaab48706c20c9eb8684882d3b87318279daedbf8216" }

    context "when inputs are valid and signature matches" do
      it "is valid" do
        expect(outcome).to be_valid
      end

      it "returns true" do
        expect(outcome.result).to be true
      end
    end

    context "when signature does not match" do
      let(:signature) { "InvalidSignature" }

      it "is invalid" do
        expect(outcome).not_to be_valid
        expect(outcome.errors[:signature]).to include("is invalid")
      end
    end

    context "when data is not provided" do
      let(:inputs) { { signature: signature } }

      it "is invalid" do
        expect(outcome).not_to be_valid
        expect(outcome.errors[:data]).to include("is required")
      end
    end

    context "when signature is not provided" do
      let(:inputs) { { data: data } }

      it "is invalid" do
        expect(outcome).not_to be_valid
        expect(outcome.errors[:signature]).to include("is required")
      end
    end
  end
end
