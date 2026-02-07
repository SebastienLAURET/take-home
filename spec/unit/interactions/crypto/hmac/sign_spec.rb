# frozen_string_literal: true

require 'rails_helper'
require 'digest'

RSpec.describe Crypto::Hmac::Sign, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { payload: payload, secret_key: secret_key } }
    let(:payload) { { "username" => "john_doe", "password" => "secret123" } }
    let(:secret_key) { "95eb51cbac2ee5e96b58d8dc79cde3bd6a5798c3a1673f7b2102679cfb12b023" }

    context "when inputs are valid" do
      it "is valid" do
        expect(outcome).to be_valid
      end

      it "returns a hash with SHA256 Base64 encoded values" do
        expect(outcome.result).to eq("29ca9635908c3a75f3bacaab48706c20c9eb8684882d3b87318279daedbf8216")
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
