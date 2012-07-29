class Rack::Campfire
  module Logging
    def log_message(message)
      return unless message.user
      puts "[rack-campfire] #{message.user.name}: #{message.body}"
    end

    def log_error(error)
      puts "[rack-campfire] #{error}"
    end
  end
end
