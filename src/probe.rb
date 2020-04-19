class Probe
  def install
    wrap(Kernel, :require)
  end

  def wrap(klass, method)
  end
end
