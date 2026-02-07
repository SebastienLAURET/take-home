# frozen_string_literal: true

class Api::Base < Grape::API
  format :json

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ error: e.message }, 404)
  end

  mount Api::V1::Root

  add_swagger_documentation(
    api_version: "v1",
    hide_documentation_path: true,
    mount_path: "/swagger_doc",
    hide_format: true
  )
end
