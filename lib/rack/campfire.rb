require 'rack'
require 'tinder'

%w[campfire].each do |file|
  require File.join(File.dirname(__FILE__), 'campfire', file)
end
