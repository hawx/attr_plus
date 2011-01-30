# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name         = "class_attr"
  s.version      = "0.1.2"
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = "attr_accessor for class level instance variables."
  s.homepage     = "http://github.com/hawx/class_attr"
  s.email        = "m@hawx.me"
  s.author       = "Joshua Hawxwell"
  s.has_rdoc     = false
  
  s.files        = %w(README.md LICENSE)
  s.files       += Dir["{bin,lib,man,spec}/**/*"] & `git ls-files -z`.split(" ")
  s.test_files   = Dir["spec/**/*"]
  
  s.require_path = 'lib'
  
  s.description  = <<-EOD
    Provides attr_accessor style methods for easily creating methods for
    working with class level instance variables. Allows you to set variables
    to be inheritable or not, and have default values.
  EOD
  
end
  
