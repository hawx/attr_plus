class Module

  def private_attr_accessor(*args)
    private_attr_writer(*args)
    private_attr_reader(*args)
  end
  
  def private_attr_writer(*args)
    attr_writer(*args)
    private(*args.map {|i| "#{i.to_s}=".to_sym })
  end
  
  def private_attr_reader(*args)
    attr_reader(*args)
    private(*args)
  end

end
