# AttrPlus

## ClassAttr

Adds `#class_attr_accessor` (and reader/writer) and `#inheritable_class_attr_accessor` (and
reader/writer of course) to Class.

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

Almost exactly the same as `class_*` but for modules. __Note__ there is no module inheritence
so `inheritable_module_*` will not work, I am thinking of adding `includable_module_*` later
but they aren't in yet so can't be used!

    module MyHouse
      module_attr_accessor :width, :height, :default => 200
      module_attr_accessor :rooms => []
      module_attr_accessor :number, :street, :city, :country
    end
    
    House.width = 500
    House.rooms = [:living_room, :kitchen]
    House.rooms.first #=> :living_room
    

## Install

    (sudo) gem install attr_plus
    

## Use

    require 'attr_plus'
    
    # or for specific methods
    require 'attr_plus/class' # for only class_*
    require 'attr_plus/module' # for only module_*
        

### Important!

If in a class you define the `self.inherited` method, make sure to call super at the end (or beginning)
otherwise default values will not be set for the subclass. But I'm guessing you already called super
anyway in a method like that.
    

## Thanks

- <http://railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/>
  For originally demystifying the class instance variable thing.
- <http://www.raulparolari.com/Rails/class_inheritable> For ideas on how to implement 
  class level attribute accessors which inherit values.


## Copyright

Copyright (c) 2010 Joshua Hawxwell. See LICENSE for details.