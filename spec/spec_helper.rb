if RUBY_VERSION >= "1.9"
  require 'duvet'
  Duvet.start :filter => 'attr_plus/lib'
end

require 'rspec'
require 'attr_plus'

RSpec.configure do |c|
  c.color_enabled = true
  c.filter_run :focus => true
  c.run_all_when_everything_filtered = true
end
