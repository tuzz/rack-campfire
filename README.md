# Rack Campfire

Rack middleware to facilitate Campfire control via a Rack application.

```
gem install rack-campfire
```

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

# Sinatra Example
The sinatra framwork is a very simple DSL that lets us create a
bare-bones web application. Here's how we might set up Sinatra with
rack-campfire:

```ruby
# config.ru
require 'sinatra'
require 'rack/campfire'

get '/' do
  'Hello, webapp!'
end

get '/campfire' do
  'Hello, campfire!'
end

use Rack::Campfire, subdomain, api_key, rooms
run Sinatra::Application
```

```subdomain``` and ```api_key``` are strings that correspond to your
bot. ```rooms``` is a list of rooms you'd like your bot to join or a
single room. It can be omitted if you only have one room.

After running ```rackup```, you should see 'Hello, campfire!' in one of the
rooms your campfire bot has joined, after posting any message in that
room. We can still visit the root of our
application, or /campfire and everything will behave as a standard web
application.

Perhaps we'd like /campfire to only respond to campfire messages? No
problem.

```ruby
# config.ru
require 'sinatra'
require 'rack/campfire'

get '/campfire' do
  if env['campfire.message']
    'Hello, campfire!'
  else
    'Hello, webapp!'
  end
end

use Rack::Campfire, subdomain, api_key, rooms
run Sinatra::Application
```

Accessing ```env``` directly feels a bit messy though, so let's clean
things up a bit.

```ruby
# config.ru
require 'sinatra'
require 'rack/campfire'

class MyApp < Sinatra::Application
  include Rack::Campfire::Hooks

  get '/campfire' do
    if message
      'Hello, campfire!'
    else
      'Hello, webapp!'
    end
  end
end

use Rack::Campfire, subdomain, api_key, rooms
run MyApp
```

As you can see, including the campfire hooks module in our application
let's us access message directly. If we visit our app through a browser,
message will be nil. So what is a message? Let's take a
look.

```
#<Hashie::Mash body="This is a test." created_at=Sat Jul 28 20:13:10 +0100 2012 id=630340875 room_id=439640 starred=false type="TextMessage" user=#<Hashie::Mash admin=false avatar_url="http://asset0.37img.com/global/missing/avatar.gif?r=3" created_at=Fri Sep 16 11:13:41 +0100 2011 email_address="chris.patuzzo@gmail.com" id=1005527 name="Chris Patuzzo" type="Member">>
```

This let's us call ```message.body``` to get the textual content, or
```message.user.email_address``` to get the email of the user who posted
the message, etc.

So it becomes trivial to write a bot that simply echoes messages back.

```ruby
get '/campfire' do
  message.body
end
```

What's really cool is when the two worlds collide. Let's create an app
that let's us hit /campfire?message=Hello in our browser and see that piped
through to our campfire rooms.

```ruby
get '/campfire' do
  rooms.each { |r| r.speak params[:message] }
  'Message sent.'
end
```

Where did rooms come from? It's just env['campfire.rooms'] and is given
to us by Hooks. So what else is available? ```room``` is available if
you're responding to a campfire message. It is the room that the message
was posted in. So we could do something like this, if we really wanted.

```ruby
get '/campfire' do
  room.speak 'Hello'
  'world'
end
```

Posting a message to the campfire room should prompt the bot to reply
'Hello' and 'world' on separate lines.

The only other things available is 'tinder'. This is an
instance of [Tinder](https://github.com/collectiveidea/tinder/). I'd
recommend looking at their documentation if you'd like to learn how your
bot could paste snippets of code, upload files, etc.

# Rails

Just like Sinatra- Rails sits on top of Rack. This means that we can use
rack-campfire inside our Rails applications. Here's how.

Add rack-campfire to your Gemfile.

```ruby
# Gemfile
gem 'rack-campfire'
```

Add rack-campfire to the middleware stack.

```ruby
# config/application.rb
config.middleware.use Rack::Campfire, subdomain, api_key, rooms
```

Add a route for campfire. You'll probably want to set it to render
textual versions of views by default.

```ruby
# config/routes.rb
match '/campfire' => 'campfire#campfire', :defaults => { :format => :text }
```

And finally, create your controller. You can include the hooks here too
if you like.

```ruby
class CampfireController < ApplicationController
  include Rack::Campfire::Hooks

  def campfire
    render :text => "Responding to #{message.body}"
  end
end
```

Remember that you can make campfire calls elsewhere too. You just won't
have a handle on message or room.

```ruby
class UsersController < ApplicationController
  include Rack::Campfire::Hooks

  def create
    # ...
    rooms.first.speak "#{params[:user][:name] just signed up!"
  end
end
```

If you're doing this frequently, I'd recommend including the hooks in
ApplicationController.

Note: You may run into problems if Rack::Campfire is not in the final
position on the middleware stack. You can test this by running rake
middleware. You can use ```config.middleware.insert_after``` in these
cases.
