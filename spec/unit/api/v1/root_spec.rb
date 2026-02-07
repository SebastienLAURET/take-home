# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Root', type: :request do
  describe 'GET /api/v1/status' do
    subject(:perform_request) { get '/api/v1/status' }

    it 'returns a successful status code' do
      perform_request
      expect(response).to have_http_status(:success)
    end

    it 'returns the expected json response' do
      perform_request
      expect(JSON.parse(response.body)).to eq({ 'status' => 'ok' })
    end
  end

  describe 'POST /api/v1/decrypt' do
    let(:params) { { username: 'encrypted_user', password: 'encrypted_pass' } }
    let(:decrypted_payload) { { username: 'john_doe', password: 'password123' } }
    let(:outcome) { instance_double(ActiveInteraction::Base, valid?: true, result: decrypted_payload) }

    before do
      allow(Crypto::Decrypt).to receive(:run).and_return(outcome)
    end

    subject(:perform_request) { post '/api/v1/decrypt', params: params }

    context 'when interaction is valid' do
      it 'returns a successful status code' do
        perform_request
        expect(response).to have_http_status(:created)
      end

      it 'calls the Crypto::Decrypt interaction' do
        expect(Crypto::Decrypt).to receive(:run).with(hash_including(payload: hash_including(params.stringify_keys))).and_return(outcome)
        perform_request
      end

      it 'returns the decrypted payload' do
        perform_request
        expect(JSON.parse(response.body)).to eq(decrypted_payload.stringify_keys)
      end
    end

    context 'when interaction is invalid' do
      let(:errors) { instance_double(ActiveModel::Errors, full_messages: [ 'Error message' ]) }
      let(:outcome) { instance_double(ActiveInteraction::Base, valid?: false, errors: errors) }

      it 'returns an unprocessable entity status code' do
        perform_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the error messages' do
        perform_request
        expect(JSON.parse(response.body)).to eq({ 'errors' => [ 'Error message' ] })
      end
    end
  end
end
