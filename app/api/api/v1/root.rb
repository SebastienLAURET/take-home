# frozen_string_literal: true

class Api::V1::Root < Grape::API
  version "v1", using: :path
  format :json

  helpers Api::Helpers

  desc "Return status of API"
  get :status do
    run_interaction Status::Get
  end

  desc "Encrypt payload"
  post :encrypt do
    run_interaction Crypto::Encrypt, { payload: params }
  end

  desc "Decrypt payload"
  post :decrypt do
    run_interaction Crypto::Decrypt, { payload: params }
  end

  desc "Sign payload"
  post :sign do
    run_interaction Crypto::Sign, { payload: params }
  end

  desc "Verify payload"
  post :verify do
    run_interaction(
      Crypto::Verify,
      params.symbolize_keys.slice(:data, :signature),
      success_status: 204
    )
  end
end
