class Probe
  def install
    wrap(Kernel, :require)
    wrap(Kernel, :require_relative)
    wrap(Kernel, :load)
  end

  def wrap(klass, method_id)
    original_method= klass.instance_method(method_id)
    klass.define_method(method_id) do
      yield(original_method.bind(self))
    end
  end

  def wrap_class_method(klass, method_id)
    original_method= klass.method(method_id)
    klass.singleton_class.define_method(method_id) do
      yield(original_method)
    end
  end
end
