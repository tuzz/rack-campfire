class Rack::Campfire
  module Logging
    def log(message)
      return unless message.user
      puts "[rack-campfire] #{message.user.name}: #{message.body}"
    end
  end
end
