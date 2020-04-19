class Probe
  def install
    wrap(Kernel, :require)
    wrap(Kernel, :require_relative)
    wrap(Kernel, :load)
  end

  def wrap(klass, method)
  end
end
