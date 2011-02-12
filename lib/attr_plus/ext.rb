# Place extra methods in here to avoid polluting Class and Module.
#
module AttrPlus

  # @param args [Array]
  # @return [Array[Array, Object]]
  #   An array where the first item is a list of arguments that were passed
  #   and the second (last) item is a default value that was given or nil.
  #
  def self.separate_arguments(args)
    if args.size == 1 && args.first.is_a?(Hash)
      [[args.first.keys[0]], args.first.values[0]]
    elsif args.last.is_a?(Hash)
      [args[0..-2], args.last[:default]]
    else
      [args, nil]
    end
  end

end