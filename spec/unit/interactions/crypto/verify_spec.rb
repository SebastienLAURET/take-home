# frozen_string_literal: true

require "rails_helper"

RSpec.describe Crypto::Verify, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { data: data, signature: signature, algorithm: algorithm } }
    let(:data) { { "message" => "Hello World", "timestamp" => 1_616_161_616 } }
    let(:signature) { "a7176bc594b111f173a34729c7ce0c431210498ed8f6bbc4eef3a5ca7a7b995d" }
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
            data: data,
            signature: signature
          }
        ).and_call_original
        outcome
      end

      it "returns valid: true" do
        expect(outcome.result).to be(true)
      end
    end

    context "when signature is invalid" do
      let(:signature) { "afzf7176bc594b111f173a34729c7ce0c431210498ed8f6bbc4eef3a5ca7a7b995d" }

      before do
        allow_any_instance_of(Crypto::Hmac::Verify).to receive(:execute).and_return(false)
      end

      it "returns valid: false" do
        expect(outcome).to be_invalid_with(:signature, :invalid)
      end
    end

    context "when data is missing" do
      let(:inputs) { { signature: signature } }

      it "is invalid" do
        expect(outcome).not_to be_valid
        expect(outcome.errors[:data]).to include("is required")
      end
    end

    context "when signature is missing" do
      let(:inputs) { { data: data } }

      it "is invalid" do
        expect(outcome).not_to be_valid
        expect(outcome.errors[:signature]).to include("is required")
      end
    end

    context "when algorithm is not provided" do
      let(:inputs) { { data: data, signature: signature } }

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
