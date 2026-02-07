# frozen_string_literal: true

require "rails_helper"

RSpec.describe Crypto::Verify, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { payload: payload, signature: signature, algorithm: algorithm } }
    let(:payload) { { "username" => "john_doe" } }
    let(:signature) { "ValidSignature" }
    let(:algorithm) { :hmac }

    context "when using hmac algorithm" do
      before do
        allow_any_instance_of(Crypto::Hmac::Verify).to receive(:execute).and_return(true)
      end

      it "is valid" do
        expect(outcome).to be_valid
      end

      it "calls Crypto::Hmac::Verify interaction" do
        expect(Crypto::Hmac::Verify).to receive(:run).with(
          {
            payload: payload,
            signature: signature
          }
        ).and_call_original
        outcome
      end

      it "returns valid: true" do
        expect(outcome.result).to eq({ valid: true })
      end
    end

    context "when signature is invalid" do
       before do
         allow_any_instance_of(Crypto::Hmac::Verify).to receive(:execute).and_return(false)
       end

       it "returns valid: false" do
         expect(outcome.result).to eq({ valid: false })
       end
    end

    context "when payload is missing" do
      let(:inputs) { { signature: signature } }

      it "is invalid" do
        expect(outcome).to be_invalid
        expect(outcome.errors[:payload]).to include("is required")
      end
    end

    context "when signature is missing" do
      let(:inputs) { { payload: payload } }

      it "is invalid" do
        expect(outcome).to be_invalid
        expect(outcome.errors[:signature]).to include("is required")
      end
    end

    context "when algorithm is not provided" do
      let(:inputs) { { payload: payload, signature: signature } }

      before do
        allow_any_instance_of(Crypto::Hmac::Verify).to receive(:execute).and_return(true)
      end

      it "defaults to hmac" do
        expect(Crypto::Hmac::Verify).to receive(:run).and_call_original
        outcome
      end
    end
  end
end
