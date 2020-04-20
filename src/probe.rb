class Probe
  def install
    wrap(Kernel, :require)
    wrap(Kernel, :require_relative)
    wrap(Kernel, :load)
  end

  def wrap(klass, method_id)
    original_method= klass.method(method_id)
    klass.define_method(method_id) do
      yield(original_method)
    end
  end
end
