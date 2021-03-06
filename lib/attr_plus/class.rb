require 'attr_plus/ext'

# Should add cattr_accessor, which provides accessors for @@ class 
# variables!

class Class
  
  # Defines a method that allows you to read an instance variable set at the
  # class level. Also defines an _instance_ method that reads the same thing.
  # Comparable to #attr_reader for the class level.
  #
  # So in summary defines: 
  # - .var (which gets @var) and 
  # - #var (which gets self.class.var)
  # 
  # @example
  #
  #   class Polygon
  #     class_attr_reader :sides
  #
  #     def self.is_a=(shape)
  #       case shape
  #         when 'triangle' then @sides = 3
  #         when 'square' then @sides = 4
  #       end
  #     end
  #   end
  #
  #   Polygon.sides #=> nil
  #   Polygon.is_a 'triangle'
  #   Polygon.sides #=> 3
  #   t = Polygon.new
  #   t.sides #=> 3
  #
  def class_attr_reader(*args)
    names, default = separate_arguments_and_set_defaults(args)
    names.each do |name|
      class_eval <<-EOS        
        def self.#{name}
          @#{name}
        end

        def #{name}
          @#{name} ||= self.class.send(:#{name}).dup
        end
      EOS
      self.instance_variable_set("@#{name}", (default.dup rescue default))
    end
  end
  
  # Defines a method for to write to an instance varaible set at the class
  # level. Comparable to #attr_writer for the class level.
  #
  # So in summary defines: .var= (which sets @var)
  #
  # @example
  #
  #   class Polygon
  #     class_attr_writer :sides
  #
  #     def self.rectangle?; @sides == 4; end
  #     def self.triangle?; @sides == 3; end
  #   end
  #
  #   Polygon.rectangle? #=> false
  #   Polygon.sides = 4
  #   Polygon.rectangle? #=> true
  #   Polygon.sides = 3
  #   Polygon.triangle? #=> true
  #
  def class_attr_writer(*args)
    names, default = separate_arguments_and_set_defaults(args)
    names.each do |name|
      class_eval <<-EOS        
        def self.#{name}=(obj)
          @#{name} = obj
        end
        
        def #{name}=(obj)
          @#{name} = obj
        end
      EOS
    end
  end
  
  # Executes #class_attr_reader and #class_attr_writer.
  #
  # @see #class_attr_reader
  # @see #class_attr_writer
  #
  # @example
  #
  #   class Polygon
  #     class_attr_accessor :sides
  #   end
  #
  #   Polygon.sides #=> nil
  #   Polygon.sides = 5
  #   Polygon.sides #=> 5
  #   pentagon = Polygon.new
  #   pentagon.sides #=> 5
  #
  def class_attr_accessor(*names)
    class_attr_reader(*names)
    class_attr_writer(*names)
  end
  
  
  # Creates a class and instance method to read the class level variable(s)
  # with the name(s) provided. If no value has been set it attempts to use
  # the value of the superclass.
  #
  # @see #class_attr_reader
  #
  def inheritable_class_attr_reader(*args)
    names, default = separate_arguments_and_set_defaults(args)
    names.each do |name|
      class_eval <<-EOS        
        def self.#{name}
          if @#{name}
            @#{name}
          elsif superclass.respond_to? :#{name}
            @#{name} ||= superclass.#{name}
          end
        end

        def #{name}
          @#{name} ||= self.class.send(:#{name})
        end
      EOS
      self.instance_variable_set("@#{name}", (default.dup rescue default))
    end
    inheritable_attrs.concat(names).uniq!
  end
  
  # The same as #class_attr_writer.
  def inheritable_class_attr_writer(*args)
    class_attr_writer(*args)
  end
  
  # Executes #inheritable_class_attr_reader and #inheritable_class_attr_writer.
  # 
  # @see #inheritable_class_attr_reader
  # @see #inheritable_class_attr_writer
  #
  # @example
  #
  #   class Polygon
  #     inheritable_class_attr_accessor :sides, :angles
  #     self.angles = [90]
  #   end
  #   
  #   class Triangle < Polygon
  #     self.sides = 3
  #     self.angles = [100, 35, 45]
  #   end
  #   
  #   class Rectangle < Polygon
  #     self.sides = 4
  #     self.angles << 60 << 100 << 110
  #   end
  #   
  #   class Square < Rectangle
  #     # should get 4 sides from rectange
  #     self.angles = [90] * 4
  #   end
  #   
  #   Polygon.sides    #=> nil
  #   Triangle.sides   #=> 3
  #   Rectangle.sides  #=> 4
  #   Rectangle.angles #=> [90, 60, 100, 110]
  #   Square.sides     #=> 4
  #   Square.angles    #=> [90, 90, 90, 90]
  #
  def inheritable_class_attr_accessor(*names)
    inheritable_class_attr_reader(*names)
    inheritable_class_attr_writer(*names)
  end
  
  
  private
  
  # Non-inheritable attrs won't get any starting value, even if it has been set
  # on a superclass so we need to save the value and set them when the class is 
  # inherited.
  #
  # @param key [Symbol]
  # @param value [Object]
  #
  def register_default(key, value)
     registered_defaults[key] = value
  end
  
  # Hash of default values, used for inheritable and non-inheritable attrs.
  def registered_defaults
    @registered_defaults ||= {}
  end
  
  # Array of symbols to call when setting up a subclass, which will provide the
  # new default values to use. This allows the current values to be inherited.
  def inheritable_attrs
    @inheritable_attrs ||= []
  end
  
  def inherited_with_attrs(klass)    
    inherited_without_attrs(klass) if respond_to?(:inherited_without_attrs)
    if registered_defaults
      new_attrs = registered_defaults.inject({}) do |a, (k, v)|
        a.update(k => (v.dup rescue v))
      end
    else
      new_attrs = {}
    end
    
    new_attrs.each do |key, value|
      result = self.send(key)
      if result
        new_attrs[key] = (result.dup rescue result)
      end # else leave as default
    end
    
    new_attrs.each do |k, v|
      klass.instance_variable_set("@#{k}", v)
    end
    klass.instance_variable_set("@registered_defaults", new_attrs)
  end
  alias inherited_without_attrs inherited
  alias inherited inherited_with_attrs
  
  # Need to use this instead of AttrPlus.separate_arguments so that any defaults
  # are properly set, but that is only with Class as this is to allow subclasses
  # to inherit the default values, Modules can't be inherited.
  #
  # BUT they can be included so I will have to look into this!
  def separate_arguments_and_set_defaults(args)
    args, default = AttrPlus.separate_arguments(args)
    if default
      args.each do |arg|
        register_default(arg, default)
      end
    end
    
    [args, default]
  end

end
