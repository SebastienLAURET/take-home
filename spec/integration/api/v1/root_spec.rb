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

  describe 'POST /api/v1/encrypt' do
    let(:params) { { username: 'john_doe', password: 'secret123' } }
    let(:expected_payload) do
      {
        'username' => Base64.encode64('john_doe'.to_json),
        'password' => Base64.encode64('secret123'.to_json)
      }
    end

    subject(:perform_request) { post '/api/v1/encrypt', params: params }

    it 'returns a successful status code' do
      perform_request
      expect(response).to have_http_status(:created)
    end

    it 'returns the encrypted payload using Base64 by default' do
      perform_request
      expect(JSON.parse(response.body)).to eq(expected_payload)
    end
  end
end
