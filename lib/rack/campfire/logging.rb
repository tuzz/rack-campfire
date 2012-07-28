class Rack::Campfire
  module Logging
    def log(message)
      puts "[rack-campfire] #{message.user.name}: #{message.body}"
    end
  end
end
