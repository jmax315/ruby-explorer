module Kernel
  alias_method :original_require, :require

  def require(name)
    puts "doing require(#{name})"
    return_value= original_require(name)
    puts "require(#{name}) returned #{return_value}"
    return_value
  end
end
