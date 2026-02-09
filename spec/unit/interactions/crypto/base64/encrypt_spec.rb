# frozen_string_literal: true

RSpec.describe Crypto::Base64::Encrypt, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { payload: payload } }
    let(:payload) { { username: "john_doe", password: "secret123" } }
    let(:encrypted_payload) { { "username" => "encrypted", "password" => "encrypted" } }

    before do
      allow(Base64).to receive(:encode64).and_return("encrypted")
    end

    context "when inputs are valid" do
      it "is valid" do
        expect(outcome).to be_valid
      end

      it "returns a hash with Base64 encoded values" do
        expect(Base64).to receive(:encode64).with("john_doe".to_json).and_return("encrypted")
        expect(Base64).to receive(:encode64).with("secret123".to_json).and_return("encrypted")

        result = outcome.result

        expect(result).to eq(encrypted_payload)
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
