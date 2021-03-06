class Rack::Campfire
  include Logging, Coercion

  def initialize(app, subdomain, api_key, rooms = nil)
    @app = app
    @campfire = campfire(subdomain, api_key)
    @rooms = coerce_rooms(rooms)
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
    log_message(message)
    return if originated_from_me?(message)
    env = mock_environment.merge('campfire.message' => message)
    response = coerce_body(@app.call(env).last)
    room.speak response unless response.empty?
  rescue => e
    log_error(e)
  end

  def params
    { 'campfire' => @campfire, 'campfire.rooms' => @rooms }
  end

  def mock_environment
    Rack::MockRequest.env_for('/campfire')
  end

  def originated_from_me?(message)
    return unless message.user
    @me ||= @campfire.me.email_address
    message.user.email_address == @me
  end
end
