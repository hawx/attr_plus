class Module
  
  # @param var [Symbol]
  #   Instance variable as a symbol, or method symbol to call which returns
  #   a hash.
  #
  # @param args [Symbol]
  #   Keys for +var+, these will have methods set up for retrieving them.
  #
  def hash_attr_reader(var, *args)
    args.each do |arg|
      self.class_eval <<-EOS
        def #{arg}
          #{var}[:#{arg}]
        end
      EOS
    end
  end
  
  # @param var [Symbol]
  #   Instance variable as a symbol, or method symbol to call which returns
  #   a hash.
  #
  # @param args [Symbol]
  #   Keys for +var+, these will have methods set up for writing to.
  #
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
