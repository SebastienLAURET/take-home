# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Root', type: :request do
  describe 'POST /api/v1/sign' do
    let(:params) { { username: 'john_doe', password: 'password123' } }
    let(:signed_payload) { { signature: 'mock_signature' } }
    let(:outcome) { instance_double(ActiveInteraction::Base, valid?: true, result: signed_payload) }

    before do
      allow(Crypto::Sign).to receive(:run).and_return(outcome)
    end

    subject(:perform_request) { post '/api/v1/sign', params: params }

    context 'when interaction is valid' do
      it 'returns a successful status code' do
        perform_request
        expect(response).to have_http_status(:created)
      end

      it 'calls the Crypto::Sign interaction' do
        expect(Crypto::Sign).to receive(:run).with(hash_including(payload: hash_including(params.stringify_keys))).and_return(outcome)
        perform_request
      end

      it 'returns the signed payload' do
        perform_request
        expect(JSON.parse(response.body)).to eq(signed_payload.stringify_keys)
      end
    end

    context 'when interaction is invalid' do
      let(:errors) { instance_double(ActiveModel::Errors, full_messages: [ 'Error message' ]) }
      let(:outcome) { instance_double(ActiveInteraction::Base, valid?: false, errors: errors) }

      it 'returns an unprocessable entity status code' do
        perform_request
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'returns the error messages' do
        perform_request
        expect(JSON.parse(response.body)).to eq({ 'errors' => [ 'Error message' ] })
      end
    end
  end
end
