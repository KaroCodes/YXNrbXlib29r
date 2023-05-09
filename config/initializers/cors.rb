Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins 'https://shark-app-i8ino.ondigitalocean.app'
        resource '*', headers: :any, methods: [:get]
    end
end