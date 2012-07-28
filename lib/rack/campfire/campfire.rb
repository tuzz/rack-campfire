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
    return if originated_from_me?(message)
    env = mock_environment.merge('campfire.message' => message)
    response = call(env).last.join("\n")
    room.speak response unless response.empty?
  end

  def params
    { 'campfire' => @campfire, 'campfire.rooms' => @rooms }
  end

  def mock_environment
    Rack::MockRequest.env_for('/campfire')
  end

  def originated_from_me?(message)
    @me ||= @campfire.me.email_address
    message.user.email_address == @me
  end

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
