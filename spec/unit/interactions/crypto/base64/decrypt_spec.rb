# frozen_string_literal: true

RSpec.describe Crypto::Base64::Decrypt, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { { payload: payload } }
    let(:payload) { { "username" => "encrypted_username", "password" => "encrypted_password" } }
    let(:decrypted_payload) { { "username" => "decrypted_value", "password" => "decrypted_value" } }

    before do
      allow(Base64).to receive(:decode64).and_return("\"json_decrypted_value\"")
      allow(JSON).to receive(:parse).and_return("decrypted_value")
    end


    context "when inputs are valid" do
      it "is valid" do
        expect(outcome).to be_valid
      end

      it "returns a hash with decrypted values" do
        result = outcome.result

        expect(result).to eq(decrypted_payload)
      end

      it "calls Base64.decode64 for each value in the payload" do
        payload.each do |key, value|
          expect(Base64).to receive(:decode64).with(value)
        end

        outcome
      end


      it "calls JSON#parse" do
        expect(JSON).to receive(:parse).with("\"json_decrypted_value\"")
        outcome
      end
    end

    context "when inputs contain invalid base64/json" do
        before do
            allow(Base64).to receive(:decode64).and_return("invalid json")
            allow(JSON).to receive(:parse).and_call_original
        end

        it "is invalid" do
             expect(outcome).to be_invalid
             expect(outcome.errors[:base]).to include("Invalid payload")
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
