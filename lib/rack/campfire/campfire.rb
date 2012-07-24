class Rack::Campfire
  include Coercion

  def initialize(app, subdomain, api_key, rooms = nil)
    @app = app
    @campfire = campfire(subdomain, api_key)
    @rooms = coerce(rooms)
    listen
  end

  def call(env)
    @app.call(env)
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
  end

  def env(message, room)
    { :message => message, :room => room, :rooms => @room, :campfire => @campfire }
  end
end
