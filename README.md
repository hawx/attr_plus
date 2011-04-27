# AttrPlus

## ClassAttr

Adds `#class_attr_accessor` (and reader/writer) and `#inheritable_class_attr_accessor` (and
reader/writer of course) to Class.

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

You can provide default values using a hash with :default set for the last value, or if just
creating one accessor/reader/writer add `=> defaultvalue` to the end, this example should
make it more clear:

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
    

## ModuleAttr

Almost exactly the same as `class_*` but for modules. __Note__ there is no module inheritance
so `inheritable_module_*` will not work, I am thinking of adding `includable_module_*` later
but they aren't in yet so can't be used!

    require 'attr_plus/module'

    module MyHouse
      module_attr_accessor :width, :height, :default => 200
      module_attr_accessor :rooms => []
      module_attr_accessor :number, :street, :city, :country
    end
    
    House.width = 500
    House.rooms = [:living_room, :kitchen]
    House.rooms.first #=> :living_room
    

## Instance Extensions

I've also added extensions to the methods for creating accessors on instances. These create
private versions, working exactly the same in every other way.

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

And then as usual there are `private_attr_accessor` and `private_attr_writer` which work
as expected.
    

## Install

    (sudo) gem install attr_plus
    

## Use

    require 'attr_plus'
    
    # or for specific methods
    require 'attr_plus/class' # for only class_*
    require 'attr_plus/module' # for only module_*
    require 'attr_plus/instance' # for only private_attr_*
        

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