require 'rack'
require 'tinder'

%w[logging campfire hooks].each do |file|
  require File.join(File.dirname(__FILE__), 'campfire', file)
end
