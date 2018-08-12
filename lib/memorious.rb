# By default objects are not memorious
class Object
  def memorious?
    false
  end
end

# Adds memory operations to method objects
class Method
  def memory
    receiver.method_memory(original_name, false) if receiver.memorious?
  end

  def forget_everything
    receiver.forget_about_method(original_name) if receiver.memorious?
  end
end

# Public: By including Memorious a class can make it methods memoized.
#
# Examples
#
#
#  class Fibonacci
#      include Memorious
#      memoize def calculate(n)
#        fail if n < 0
#        return n if n.zero? || n == 1
#        calculate(n - 1) + calculate(n - 2)
#      end
#    end
#
module Memorious
  def self.included(base)
    base.extend(ClassSide)
    base.include(InstanceSide)
  end

  # Private: Class methods to be added to the class
  module ClassSide
    # Public: memoize adds memory to a method
    def memoize(method_name)
      memo = Memo.new(instance_method(method_name))
      define_method(method_name) { |*args| memo.call(*[self] + args) }
    end
  end

  # Private: Instance methods to be added to the class
  module InstanceSide
    # Public: Says wheather the class of the instance supports memoization
    def memorious?
      true
    end

    # Returns the execution memory of a method
    def method_memory(method_name, create = false)
      create_memory_if_not_exists
      return @_mem[method_name] = {} if !@_mem.key?(method_name) && create
      @_mem[method_name]
    end

    # Erases the memory of a method
    def forget_about_method(method_name)
      return unless instance_variable_defined?(:@_mem)
      @_mem[method_name] = nil
    end

    # Creates the method memory instance variable if it doesn't exist
    def create_memory_if_not_exists
      instance_variable_set(:@_mem, {}) \
        unless instance_variable_defined?(:@_mem)
    end
  end
end

# Private: A Memo intercepts a method and caches all its invocations. 
class Memo
  def initialize(method)
    @method = method
  end

  def call(*args)
    receiver, *arguments = args
    mem = receiver.method_memory(@method.name, true)
    if mem.key?(arguments)
      mem[arguments]
    else
      mem[arguments] = @method.bind(receiver).call(*arguments)
    end
  end
end
