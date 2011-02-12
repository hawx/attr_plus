require 'attr_plus/ext'

class Module
  
  def module_attr_reader(*args)
    names, default = AttrPlus.separate_arguments(args)
    names.each do |name|
      module_eval <<-EOS
        def self.#{name}
          @#{name}
        end
      EOS
      self.instance_variable_set("@#{name}", (default.dup rescue default))
    end
  end
  
  def module_attr_writer(*args)
    names, default = AttrPlus.separate_arguments(args)
    names.each do |name|
      module_eval <<-EOS
        def self.#{name}=(obj)
          @#{name} = obj
        end
      EOS
    end
  end
  
  def module_attr_accessor(*args)
    module_attr_reader(*args)
    module_attr_writer(*args)
  end
  
end