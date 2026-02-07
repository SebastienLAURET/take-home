module V1
  class Root < Grape::API
    version "v1", using: :path
    format :json

    desc "Return status of API"
    get :status do
      { status: "ok" }
    end
  end
end
