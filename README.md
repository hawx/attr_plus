# ClassAttr

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
    

### Install

    (sudo) gem install class_attr
    

### Use

    require 'class_attr'
    

## Thanks

- <http://railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/]>
  For originally demystifying the class instance variable thing.
- <http://www.raulparolari.com/Rails/class_inheritable> For ideas on how to implement 
  class level attribute accessors which inherit values.


## Copyright

Copyright (c) 2010 Joshua Hawxwell. See LICENSE for details.