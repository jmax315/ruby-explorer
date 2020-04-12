def wrap(klass, method_id)
  original_method= klass.method(method_id)
  klass.define_method(method_id) do |*args|
    puts "doing #{method_id}(#{args.join(', ')})"
    return_value= original_method.call(*args)
    puts "orignal #{method_id} returned #{return_value}"
    return_value
  end
end

wrap(Kernel, :require)
