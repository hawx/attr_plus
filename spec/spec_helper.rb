if RUBY_VERSION >= "1.9"
  require 'duvet'
  Duvet.start :filter => 'class_attr/lib'
end

require 'rspec'
require 'attr_plus'

RSpec.configure do |config|
  config.color_enabled = true
end