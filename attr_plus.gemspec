# -*- encoding: utf-8 -*-
require File.expand_path("../lib/attr_plus/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "attr_plus"
  s.version      = AttrPlus::VERSION
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = "attr_accessor for class and module level instance variables."
  s.homepage     = "http://github.com/hawx/attr_plus"
  s.email        = "m@hawx.me"
  s.author       = "Joshua Hawxwell"
  s.has_rdoc     = false
  
  s.files        = %w(README.md LICENSE)
  s.files       += Dir["{bin,lib,man,spec}/**/*"] & `git ls-files -z`.split(" ")
  s.test_files   = Dir["spec/**/*"]
  
  s.require_path = 'lib'
  
  s.description  = <<-EOD
    Provides attr_accessor style methods for easily creating methods for
    working with class level instance variables and module level instance
    variables. Variables can be inherited and have default values.
  EOD
  
end
  
