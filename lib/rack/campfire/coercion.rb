class Rack::Campfire
  module Coercion
    def coerce(rooms)
      case rooms
      when :all
        @campfire.rooms
      when nil
        [@campfire.rooms.first]
      when Integer
        [@campfire.find_room_by_id(rooms)]
      when String
        [@campfire.find_room_by_name(rooms)]
      when Array
        rooms.inject([]) do |array, room|
          case room
          when Integer
            array += @campfire.find_room_by_id(room)
          when String
            array += @campfire.find_room_by_name(room)
          end
        end
      end
    end
  end
end
