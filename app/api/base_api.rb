class BaseApi < Grape::API
  format :json

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ error: e.message }, 404)
  end

  rescue_from :all do |e|
    Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
    error!({ error: "Internal Server Error" }, 500)
  end

  mount V1::Root

  add_swagger_documentation(
    api_version: "v1",
    hide_documentation_path: true,
    mount_path: "/swagger_doc",
    hide_format: true
  )
end
