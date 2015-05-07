class Class
  def is_descended?(type)
    self.ancestors.include? type
  end
end

class PartialBlock < Proc

  attr_accessor :block, :parameters_types

  def initialize (some_parameters_types, &one_block)

    self.block = one_block
    self.parameters_types = some_parameters_types
  end

  def matches(*some_arguments)
    return (self.same_lists_size?(some_arguments, self.parameters_types) && self.same_parameters_type(*some_arguments))
  end

  def matches_types(some_types)
    return (self.same_lists_size?(some_types, self.parameters_types) && self.same_parameters_types?(some_types))
  end


  def call(*some_parameters)

    if (!self.matches(*some_parameters))
      raise ArgumentError.new('La cantidad de parametros informados no coinciden con la cantidad de parametros usados en el bloque')
    end

    self.block.call(some_parameters)
  end

  def same_lists_size?(list1, list2)
    return list1.size == list2.size
  end

  def same_parameters_type(*some_arguments)
    (some_arguments.zip self.parameters_types).all? do |argument, parameter_type| argument.is_a? parameter_type end
  end

  def same_parameters_types?(some_types)
    (some_types.zip self.parameters_types).all? do |type, parameter_type| type.is_descended? parameter_type end
  end

  def distance_to(*arguments)
    ((arguments.zip self.parameters_types).collect { |argument,parameter_type| self.distance_between(argument,parameter_type) }).reduce(:+)
  end

  def distance_between(argument,parameter_type)
    argument.class.ancestors.index(parameter_type)
  end

end