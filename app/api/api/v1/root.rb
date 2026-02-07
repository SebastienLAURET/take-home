# frozen_string_literal: true

class Api::V1::Root < Grape::API
  version "v1", using: :path
  format :json

  helpers Api::Helpers

  desc "Return status of API"
  get :status do
    run_interaction Status::Get
  end
end
