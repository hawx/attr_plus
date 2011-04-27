# Add hash_attr_* to (either Class, Object or Module, probably Object or
# maybe even Kernel do some testing) this allows you to set up keys in a 
# hash as attributes.
#
# @example
#
#   class Thing
#     def initialize(name, age)
#       @config = {
#         :name => name,
#         :age => age
#       }
#     end
#
#     hash_attr_accessor :@config, :name, :age
#
#     # or 
#     hash_attr_accessor :@options, 
#                        :keys => [:name, :age], 
#                        :default => {:name => "John Doe"}
#     # obviously therefore `options[:age] #=> nil`
#
#   end
#
#   tom = Thing.new("Tom", 20)
#   tom.config #=> {:name => "Tom", :age => 20}
#   tom.name #=> "Tom"
#   tom.age #=> 20
#   tom.age += 5
#   tom.config #=> {:name => "Tom", :age => 25}
#
# These methods should be aliased as hattr_*, and maybe also allow 
# access to the keys with strings and symbols?
#


class Module
  
  def hash_attr_reader(var, *args)
    args.each do |arg|
      self.class_eval <<-EOS
        def #{arg}
          #{var}[:#{arg}]
        end
      EOS
    end
  end
  
  def hash_attr_writer(var, *args)
    args.each do |arg|  
      self.class_eval <<-EOS
        def #{arg}=(val)
          #{var}[:#{arg}] = val
        end
      EOS
    end
  end
  
  def hash_attr_accessor(*args)
    hash_attr_reader(*args)
    hash_attr_writer(*args)
  end
  
  # Like #hash_attr_accessor but creates class methods  
  def class_hash_attr_accessor(*args)
    class_hash_attr_reader(*args)
    class_hash_attr_writer(*args)
  end
  
  def class_hash_attr_reader(var, *args)
    args.each do |arg|
      self.instance_eval <<-EOS
        def #{arg}
          #{var}[:#{arg}]
        end
      EOS
    end
  end
  
  def class_hash_attr_writer(var, *args)
    args.each do |arg|  
      self.instance_eval <<-EOS
        def #{arg}=(val)
          #{var}[:#{arg}] = val
        end
      EOS
    end
  end
  
end
