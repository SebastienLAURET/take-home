# frozen_string_literal: true

require "rails_helper"

RSpec.describe Crypto::Sign, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { payload: payload, algorithm: algorithm } }
    let(:payload) { { "username" => "john_doe", "password" => "secret123" } }
    let(:signed_payload) { { "signature" => "mock_signature" } }
    let(:algorithm) { :hmac }

    context "when using hmac algorithm" do
      before do
        allow_any_instance_of(Crypto::Hmac::Sign).to receive(:execute).and_return("mock_signature")
      end

      it "is valid" do
        expect(outcome).to be_valid
      end

      it "calls Crypto::Hmac::Sign interaction" do
        expect(Crypto::Hmac::Sign).to receive(:run).with(hash_including(payload: payload.stringify_keys)).and_call_original

        outcome
      end

      it "returns signed payload" do
        result = outcome.result

        expect(result.stringify_keys).to eq(signed_payload.stringify_keys)
      end
    end

    context "when payload is empty" do
      let(:payload) { nil }

      it "is valid" do
        expect(outcome).to be_invalid_with(:payload, :missing)
      end
    end

    context "when algorithm is not provided" do
      let(:inputs) { { payload: payload } }

      before do
        allow_any_instance_of(Crypto::Hmac::Sign).to receive(:execute).and_return("mock_signature")
      end

      it "is valid" do
        expect(outcome).to be_valid
      end

      it "uses base64 as default algorithm" do
        expect(Crypto::Hmac::Sign).to(
          receive(:run)
              .with(hash_including(payload: payload.stringify_keys))
              .and_call_original
        )

        outcome
      end

      it "returns signed payload with default algorithm" do
        result = outcome.result

        expect(result.stringify_keys).to eq(signed_payload.stringify_keys)
      end
    end

    context "when algorithm is invalid" do
      let(:algorithm) { :invalid_algorithm }

      it "is invalid" do
        expect(outcome).to be_invalid_with(:algorithm, :inclusion)
      end
    end

    context "when payload is not provided" do
      let(:inputs) { { algorithm: algorithm } }

      it "is invalid" do
        expect(outcome).to be_invalid_with(:payload, :missing)
      end
    end
  end
end
