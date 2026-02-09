# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Root", type: :request do
  describe "GET /api/v1/status" do
    subject(:perform_request) { get "/api/v1/status" }

    it "returns a successful status code" do
      perform_request
      expect(response).to have_http_status(:success)
    end

    it "returns the expected json response" do
      perform_request
      expect(JSON.parse(response.body)).to eq({ "status" => "ok" })
    end
  end

  describe "POST /api/v1/encrypt" do
    subject(:perform_request) { post "/api/v1/encrypt", params: params }

    let(:params) do
      {
        name: "John Doe",
        age: 30,
        contact: {
          email: "john@example.com",
          phone: "123-456-7890"
        }
      }
    end

    let(:expected_payload) do
      {
        name: "IkpvaG4gRG9lIg==\n",
        age: "IjMwIg==\n",
        contact: "eyJlbWFpbCI6ImpvaG5AZXhhbXBsZS5jb20iLCJwaG9uZSI6IjEyMy00NTYt\nNzg5MCJ9\n"
      }
    end

    it "returns a successful status code" do
      perform_request
      expect(response).to have_http_status(:created)
    end

    it "returns the encrypted payload using Base64 by default" do
      perform_request
      expect(JSON.parse(response.body).deep_symbolize_keys).to eq(expected_payload)
    end
  end

  describe "POST /api/v1/decrypt" do
    subject(:perform_request) { post "/api/v1/decrypt", params: params }

    let(:params) do
      {
        name: "IkpvaG4gRG9lIg==\n",
        age: "MzA=\n",
        contact: "eyJlbWFpbCI6ImpvaG5AZXhhbXBsZS5jb20iLCJwaG9uZSI6IjEyMy00NTYt\nNzg5MCJ9\n"
      }
    end
    let(:expected_payload) do
      {
        name: "John Doe",
        age: 30,
        contact: {
          email: "john@example.com",
          phone: "123-456-7890"
        }
      }
    end

    it "returns a successful status code" do
      perform_request
      expect(response).to have_http_status(:created)
    end

    it "returns the decrypted payload using Base64 by default" do
      perform_request
      expect(JSON.parse(response.body).deep_symbolize_keys).to eq(expected_payload)
    end
  end

  describe "POST /api/v1/sign" do
    subject(:perform_request) { post "/api/v1/sign", params: params }

    let(:params) { { username: "john_doe", password: "secret123" } }
    let(:secret) { "secret" }
    let(:expected_payload) do
      {
        "signature" => "0194efdabbb238ae3394f5ff14fb7f0c8a4e8deb03990ea572c4aa59be9fd60e"
      }
    end

    it "returns a successful status code" do
      perform_request
      expect(response).to have_http_status(:created)
    end

    it "returns the signed payload using HMAC-SHA256/Base64 by default" do
      perform_request
      expect(JSON.parse(response.body)).to eq(expected_payload)
    end
  end

  describe "POST /api/v1/verify" do
    subject(:perform_request) { post "/api/v1/verify", params: params }

    let(:payload) { { username: "john_doe", password: "secret123" } }
    let(:signature) { "0194efdabbb238ae3394f5ff14fb7f0c8a4e8deb03990ea572c4aa59be9fd60e" }

    let(:params) do
      {
        data: payload,
        signature: signature
      }
    end

    it "calls verify interaction and returns success" do
      perform_request
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
    end
  end
end
