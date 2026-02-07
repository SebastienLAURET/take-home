# frozen_string_literal: true

RSpec.describe Status::Get, type: :interaction do
  describe "#execute" do
    subject(:outcome) { described_class.run(inputs) }

    let(:inputs) { {} }

    it "is valid" do
      expect(outcome).to be_valid
    end

    it "returns the expected status result" do
      expect(outcome.result).to eq({ status: "ok" })
    end
  end
end
