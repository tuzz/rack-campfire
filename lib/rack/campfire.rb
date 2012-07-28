require 'rack'
require 'tinder'

%w[logging coercion campfire hooks].each do |file|
  require File.join(File.dirname(__FILE__), 'campfire', file)
end
