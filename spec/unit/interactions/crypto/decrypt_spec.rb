# frozen_string_literal: true

RSpec.describe Crypto::Decrypt, type: :interaction do
    describe "#execute" do
        subject(:outcome) { described_class.run(inputs) }

        let(:inputs) { { payload: payload, algorithm: algorithm } }
        let(:payload) { { "username" => "encrypted", "password" => "encrypted" } }
        let(:decrypted_payload) { { "username" => "john_doe", "password" => "secret123" } }
        let(:algorithm) { :base64 }


        context "when using base64 algorithm" do
            before do
                allow_any_instance_of(Crypto::Base64::Decrypt).to receive(:execute).and_return(decrypted_payload)
            end


            it "is valid" do
                expect(outcome).to be_valid
            end

            it "calls Crypto::Base64::Decrypt interaction" do
                expect(Crypto::Base64::Decrypt).to receive(:run).with(hash_including(payload: payload.stringify_keys)).and_call_original

                outcome
            end

            it "returns decrypted payload" do
                result = outcome.result

                expect(result).to eq(decrypted_payload)
            end
        end

        context "when payload is empty" do
            let(:payload) { {} }

            it "is valid" do
                expect(outcome).to be_valid
            end

            it "returns an empty hash" do
                expect(outcome.result).to eq({})
            end
        end

        context "when algorithm is not provided" do
        let(:inputs) { { payload: payload } }

            before do
                allow_any_instance_of(Crypto::Base64::Decrypt).to receive(:execute).and_return(decrypted_payload)
            end

            it "is valid" do
                expect(outcome).to be_valid
            end

            it "uses base64 as default algorithm" do
                expect(Crypto::Base64::Decrypt).to(
                    receive(:run)
                        .with(hash_including(payload: payload.stringify_keys))
                        .and_call_original
                )

                outcome
            end

            it "returns decrypted payload with default algorithm" do
                result = outcome.result

                expect(result).to eq(decrypted_payload)
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
