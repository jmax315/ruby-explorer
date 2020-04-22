class Probe
  def install
    wrap(Kernel, :require) do |original_require, args|
      puts "require(#{args})"
      return_value= original_require.call(*args)
      puts "require(#{args}): returned #{return_value}"
      return_value
    end

    wrap(Kernel, :require_relative) do |original_require_relative, args|
      puts "require_relative(#{args})"
      return_value= original_require_relative.call(*args)
      puts "require_relative(#{args}): returned #{return_value}"
      return_value
    end

    wrap(Kernel, :load) do |original_load, args|
      puts "load(#{args})"
      return_value= original_load.call(*args)
      puts "load(#{args}): returned #{return_value}"
      return_value
    end
  end

  def wrap(klass, method_id)
    original_method= klass.instance_method(method_id)
    klass.define_method(method_id) do |*args|
      yield(original_method.bind(self), args)
    end
  end

  def wrap_class_method(klass, method_id)
    original_method= klass.method(method_id)
    klass.singleton_class.define_method(method_id) do |*args|
      yield(original_method, args)
    end
  end
end
