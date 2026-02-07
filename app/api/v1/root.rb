# frozen_string_literal: true

class V1::Root < Grape::API
  version "v1", using: :path
  format :json

  desc "Return status of API"
  get :status do
    { status: "ok" }
  end
end
