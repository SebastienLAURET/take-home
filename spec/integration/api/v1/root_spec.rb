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
end
