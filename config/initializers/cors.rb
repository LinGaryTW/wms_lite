Rails.application.config.action_controller.forgery_protection_origin_check = false
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
