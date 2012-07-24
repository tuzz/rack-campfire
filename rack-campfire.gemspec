Gem::Specification.new do |s|
  s.name        = 'rack-campfire'
  s.version     = '0.0.1'
  s.summary     = 'Rack Campfire'
  s.description = 'Rack middleware to facilitate Campfire control via a Rack application'
  s.author      = 'Christopher Patuzzo'
  s.email       = 'chris.patuzzo@gmail.com'
  s.homepage    = 'https://github.com/cpatuzzo/rack-campfire'
  s.files       = ['README.md'] + Dir['lib/**/*.*']

  s.add_dependency 'rack'
  s.add_dependency 'tinder'
end
