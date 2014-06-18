$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))

require 'innkeeper'

require 'rubygems'
require 'rack'

Dir[File.join(File.dirname(__FILE__), 'helpers', '**/*.rb')].each do |f|
  require f
end

RSpec.configure do |config|
  config.include(Innkeeper::Spec::Helpers)
end