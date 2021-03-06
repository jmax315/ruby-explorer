require "pathname"

class Probe
  def install
    wrap(Kernel, :require) do |original_require, args|
      return_value= original_require.call(*args)
      puts "require(#{args.first}): #{require_message(return_value, args.first, $LOADED_FEATURES)}"
      return_value
    end

    wrap(Kernel, :require_relative) do |original_require_relative, args|
      return_value= require("#{caller_directory}/#{args.first}")
      puts "require_relative(#{args.first}): #{require_message(return_value, args.first, $LOADED_FEATURES)}"
      return_value
    end

    wrap(Kernel, :load) do |original_load, args|
      return_value= original_load.call(*args)
      puts "load(#{args.first}): #{load_message(args.first, $LOAD_PATH)}"
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

  def caller_directory
    Pathname.new(caller(3,1).first.split(":").first).dirname.to_s
  end

  def require_message(loaded, file, loaded_features)
    absolute_file= require_file(file, loaded_features)

    if !loaded
      "already loaded"
    elsif absolute_file
      "loaded #{absolute_file}"
    else
      "couldn't find loaded file"
    end
  end

  def require_file(file, loaded_features)
    base_file= Pathname.new(file).basename.to_s

    if base_file =~ /.*(\.rb|\.so)$/
      match_pattern= /.*\/#{base_file}$/
    else
      match_pattern= /.*\/#{base_file}(\.rb|\.so)$/
    end

    loaded_features.reverse_each do |loaded_file|
      return loaded_file if loaded_file =~ match_pattern
    end

    nil
  end

  def load_file(filename, load_path)
    loaded_file= File.expand_path(filename)

    if File.exists?(loaded_file)
      return loaded_file
    end

    load_path.each do |path|
      loaded_file= "#{path}/#{filename}"
      if File.exists?(loaded_file)
        return loaded_file
      end
    end

    nil
  end

  def load_message(filename, load_path)
    found_file= load_file(filename, load_path)
    if found_file
      "loaded #{found_file}"
    else
      "couldn't find file"
    end
  end
end
