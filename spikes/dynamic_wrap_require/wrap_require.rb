def wrap_require
  original_require= Kernel.method(:require)
  Kernel.define_method(:require) do |*args|
    puts "doing require(#{args[0]})"
    return_value= original_require.call(*args)
    puts "orignal returned #{return_value}"
    return_value
  end
end

wrap_require
