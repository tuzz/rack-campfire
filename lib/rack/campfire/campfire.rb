class Rack::Campfire
  def initialize(app, subdomain, api_key, rooms = nil)
    @app = app
    @campfire = campfire(subdomain, api_key)
    @rooms = coerce(rooms)
    listen
  end

  def call(env)
    @app.call(env.merge(params))
  end

  private
  def campfire(subdomain, api_key)
    Tinder::Campfire.new(subdomain, :token => api_key)
  end

  def listen
    @rooms.each { |r| Thread.new { r.listen { |m| respond(m, r) } } }
  end

  def respond(message, room)
    @app.call(env(message, room))
  def params
    { 'campfire' => @campfire, 'campfire.rooms' => @rooms }
  end
  end

  def env(message, room)
    { :message => message, :room => room, :rooms => @rooms, :campfire => @campfire }
  def coerce(rooms)
    case rooms
    when nil
      [@campfire.rooms.first]
    when String
      [@campfire.find_room_by_name(rooms)]
    when Array
      rooms.map { |r| @campfire.find_room_by_name(r) }
    end
  end
end
