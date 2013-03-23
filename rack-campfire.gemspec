Gem::Specification.new do |s|
  s.name        = 'rack-campfire'
  s.version     = '0.0.3'
  s.summary     = 'Rack Campfire'
  s.description = 'Rack middleware to facilitate Campfire control via a Rack application'
  s.author      = 'Chris Patuzzo'
  s.email       = 'chris@patuzzo.co.uk'
  s.homepage    = 'https://github.com/tuzz/rack-campfire'
  s.files       = ['README.md'] + Dir['lib/**/*.*']

  s.add_dependency 'rack'
  s.add_dependency 'tinder'
end
