class Rack::Campfire
  module Hooks
    def tinder
      env['campfire']
    end

    def rooms
      env['campfire.rooms']
    end

    def room
      return unless message
      rooms.detect { |r| r.room_id == message.room_id }
    end

    def message
      env['campfire.message']
    end
  end
end
