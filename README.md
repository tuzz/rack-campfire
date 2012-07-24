# Rack Campfire

Rack middleware to facilitate Campfire control via a Rack application

*Work in progress (unreleased)*

# Concept
A campfire bot is responsible for listening to requests and responding
to them.

A web application is responsible for listening to requests and
responding to them.

Do you see a theme emerging?

Wouldn't it be nice if we could write a web application which is in fact
a campfire bot? That way, we could treat users' campfire messages as
requests and respond using the knowledge we've built up over our years
of web programming. That's what rack-campfire let's you do.

There's nothing stopping you running it alongside your current applications either. So it should be
trivial to plug it into your Rails applications and handle Campfire
messages in your campfire_controller, etc.

# Usage
```ruby
# config.ru
use Rack::Campfire, subdomain, api_key, rooms

# A very simple Rack app that puts, or renders its environment variables
run Proc.new { |env| [200, { 'Content-Type' => 'text/plain' }, [
  (puts env.inspect).to_s,
  env.inspect
]] }
```

Rooms can be an id, a string, a mixed array. If rooms is nil, the first
room will be chosen.
