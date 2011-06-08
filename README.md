# AttrPlus

## ClassAttr

Adds `class_attr_accessor` (and reader/writer) and `inheritable_class_attr_accessor` (and
reader/writer of course) to Class.

``` ruby
require 'attr_plus'

class Polygon
  class_attr_accessor :sides
end

Polygon.sides = 5
Polygon.sides #=> 5

class Square < Polygon
end

Square.sides #=> nil


class InheritablePolygon
  inheritable_class_attr_accessor :sides
end

Polygon.sides = 4

class NewSquare < Polygon
end

Square.sides #=> 4
```

You can provide default values using a hash with :default set for the last value, or if just
creating one accessor/reader/writer add `=> defaultvalue` to the end, this example should
make it more clear:

``` ruby
require 'attr_plus/class'

class Person
  class_attr_accessor :name => 'John Doe'
  inheritable_class_attr_accessor :arms, :legs, :default => 2
  inheritable_class_attr_accessor :fingers, :toes, :default => 5
end

class Agent < Person
  @name = "James Bond"
end  

Person.name #=> "John Doe"
Person.arms #=> 2
Person.toes #=> 5
Agent.name  #=> "James Bond"
Agent.legs  #=> 2
```
    

## ModuleAttr

Almost exactly the same as `class_*` but for modules.

``` ruby
require 'attr_plus/module'

module MyHouse
  module_attr_accessor :width, :height, :default => 200
  module_attr_accessor :rooms => []
  module_attr_accessor :number, :street, :city, :country
end

House.width = 500
House.rooms = [:living_room, :kitchen]
House.rooms.first #=> :living_room
```
    

## Instance Extensions

I've also added extensions to the methods for creating accessors on instances. These create
private versions, working exactly the same in every other way.

``` ruby
require 'attr_plus/instance'

class SecretBox
  attr_writer :stuff
  private_attr_reader :stuff
  
  def initialize
    @stuff = []
  end
  
  def <<(val)
    stuff << val
  end
  
  def shake
    stuff[rand(stuff.size)]
  end
end

box = SecretBox.new
box << "giraffe"
box << "elephant"
box << "camel"
box << "cat"
p box.shake #=> "giraffe"
p box.stuff # NoMethodError: private method 'stuff' called
box.stuff = %w(dog hamster fish)
p box.shake #=> "fish"
```

And then as usual there are `private_attr_accessor` and `private_attr_writer` which work
as expected.
    

## HashAttr

You can now access specific keys of a hash using `hash_attr_*` or `class_hash_attr_*`. The
normal version will get the variable in an instance but the class version works at the class
level, for example,

``` ruby
require_relative 'lib/attr_plus/hash'

class SomeApp
  @config = {:name => 'SomeApp', :version => '3.1.7'}
  class_hash_attr_accessor :@config, :name, :version
  
  def self.config; @config; end
end

p SomeApp.config #=> {:name => 'SomeApp', :version => '3.1.7'}
SomeApp.name = 'CoolApp'
p SomeApp.name #=> 'CoolApp'
SomeApp.version = '4.0.0'
p SomeApp.config #=> {:name => 'CoolApp', :version => '4.0.0'}
```

Uses the class versions, but it could easily be written using the normal versions (probably
the most usual way):

``` ruby
class AnApp
  def initialize
    @config = {}
  end
  
  hash_attr_accessor :@config, :name, :version
  attr_accessor :config
end

some_app = AnApp.new
some_app.name = 'AnotherApp'
some_app.version = '1.5.0'
p some_app.config #=> {:name => 'AnotherApp', :version => '1.5.0'}
```

In both of these I've passed the instance variable as a symbol as the argument to get the hash
but I could have used just `:config` as I have create the methods in each. If the hash uses 
string keys just pass the arguments to `.hash_attr_` as strings instead of symbols.


## Install

``` bash
$ (sudo) gem install attr_plus
```
    

## Use

``` ruby
require 'attr_plus'

# OR for specific methods
require 'attr_plus/class'    # for only class_*
require 'attr_plus/module'   # for only module_*
require 'attr_plus/hash'     # for only hash_*
require 'attr_plus/instance' # for only private_attr_*
```
        

### Important!

If in a class you define the `self.inherited` method, make sure to call super 
somewhere otherwise default values will not be set for the subclass.
    

## Thanks

- <http://railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/>
  For originally demystifying the class instance variable thing.
- <http://www.raulparolari.com/Rails/class_inheritable> For ideas on how to implement 
  class level attribute accessors which inherit values.


## Copyright

Copyright (c) 2010 Joshua Hawxwell. See LICENSE for details.