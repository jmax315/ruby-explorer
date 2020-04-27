require "./src/probe"

describe "Probe" do
  let(:the_probe) { Probe.new }

  describe "#insert" do
    before do
      allow(the_probe).to receive(:wrap)

      the_probe.install
    end

    it "wraps require" do
      expect(the_probe).to have_received(:wrap).with(Kernel, :require)
    end

    it "wraps require_relative" do
      expect(the_probe).to have_received(:wrap).with(Kernel, :require_relative)
    end

    it "wraps load" do
      expect(the_probe).to have_received(:wrap).with(Kernel, :load)
    end
  end

  describe "#wrap" do
    class WrapTarget
      attr_accessor :a_method_called, :arg_value

      def initialize
        @a_method_called= false
        @arg_value= nil
      end

      def a_method(arg)
        @a_method_called= true
        @arg_value= arg
        return "a_method expected return value"
      end
    end

    let(:wrap_target) { WrapTarget.new }

    before do
      @got_called_back= false
      the_probe.wrap(WrapTarget, :a_method) do |original_method, args|
        @got_called_back= true
        original_method.call(*args)
      end

      wrap_target.a_method("expected arg value")
    end

    it "calls the wrap block back" do
      expect(@got_called_back).to be(true)
    end

    it "calls the original method" do
      expect(wrap_target.a_method_called).to be(true)
    end

    it "passes the arg value through" do
      expect(wrap_target.arg_value).to eq("expected arg value")
    end

    it "returns the original return value" do
      expect(wrap_target.a_method("")).to eq("a_method expected return value")
    end
  end

  describe "#wrap_class_method" do
    class WrapClassMethodTarget
      @@a_class_method_called= false
      @@arg_value= nil

      def self.a_class_method(arg)
        @@a_class_method_called= true
        @@arg_value= arg
        return "a_class_method expected return value"
      end
    end

    before do
      @got_called_back= false
      the_probe.wrap_class_method(WrapClassMethodTarget, :a_class_method) do |original_method, args|
        @got_called_back= true
        original_method.call(*args)
      end

      WrapClassMethodTarget.a_class_method("expected arg value")
    end

    it "calls the wrap block back" do
      expect(@got_called_back).to be(true)
    end

    it "calls the original method" do
      expect(WrapClassMethodTarget.class_variable_get(:@@a_class_method_called)).to be(true)
    end

    it "passes the arg value through" do
      expect(WrapClassMethodTarget.class_variable_get(:@@arg_value)).to eq("expected arg value")
    end

    it "returns the original return value" do
      expect(WrapClassMethodTarget.a_class_method("")).to eq("a_class_method expected return value")
    end
  end

  describe "#wrap on a module method" do
    module WrapModule
      def a_module_method(arg)
        @a_module_method_called= true
        @arg_value= arg
        return "a_module_method expected return value"
      end
    end

    class WrapModuleMethodTarget
      include WrapModule

      attr_accessor :a_module_method_called, :arg_value

      def initialize
        @a_module_method_called= false
        @arg_value= nil
      end
    end

    let(:wrap_target) { WrapModuleMethodTarget.new }

    before do
      @got_called_back= false
      the_probe.wrap(WrapModule, :a_module_method) do |original_method, args|
        @got_called_back= true
        original_method.call(*args)
      end

      wrap_target.a_module_method("expected arg value")
    end

    it "calls the wrap block back" do
      expect(@got_called_back).to be(true)
    end

    it "calls the original method" do
      expect(wrap_target.a_module_method_called).to be(true)
    end

    it "passes the arg value through" do
      expect(wrap_target.arg_value).to eq("expected arg value")
    end

    it "returns the original return value" do
      expect(wrap_target.a_module_method("")).to eq("a_module_method expected return value")
    end
  end

  describe "caller_directory" do
    def original_caller
      second_caller
    end

    def second_caller
      the_probe.caller_directory
    end

    it "returns the directory of the third back caller" do
      expect(original_caller).to eq(Pathname.new(__FILE__).dirname.to_s)
    end
  end

  describe "required_file" do
    it "doesn't find a file that hasn't been loaded" do
      expect(the_probe.required_file("a-file", [])).to be_nil
    end

    it "finds a loaded file with no path and no extension when the loaded file has a .rb extension" do
      expect(the_probe.required_file("a-file", ["/some/path/wrong-file.rb", "/some/path/a-file.rb"])).
        to eq("/some/path/a-file.rb")
    end

    it "finds a loaded file with no path and no extension when the loaded file has a .so extension" do
      expect(the_probe.required_file("a-file", ["/some/path/wrong-file.rb", "/some/path/a-file.so"])).
        to eq("/some/path/a-file.so")
    end

    it "finds a loaded file with no path and an .rb extension when the loaded file has a .rb extension" do
      expect(the_probe.required_file("a-file.rb", ["/some/path/wrong-file.rb", "/some/path/a-file.rb"])).
        to eq("/some/path/a-file.rb")
    end

    it "finds a loaded file with no path and an .so extension when the loaded file has a .so extension" do
      expect(the_probe.required_file("a-file.so", ["/some/path/wrong-file.rb", "/some/path/a-file.so"])).
        to eq("/some/path/a-file.so")
    end

    it "finds a loaded file with a path and no extension when the loaded file has a .rb extension" do
      expect(the_probe.required_file("../a-file", ["/some/path/wrong-file.rb", "/some/path/a-file.rb"])).
        to eq("/some/path/a-file.rb")
    end

    it "finds a loaded file with a path and no extension when the loaded file has a .so extension" do
      expect(the_probe.required_file("../a-file", ["/some/path/wrong-file.rb", "/some/path/a-file.so"])).
        to eq("/some/path/a-file.so")
    end

    it "finds a loaded file with a path and an .rb extension when the loaded file has a .rb extension" do
      expect(the_probe.required_file("../a-file.rb", ["/some/path/wrong-file.rb", "/some/path/a-file.rb"])).
        to eq("/some/path/a-file.rb")
    end

    it "finds a loaded file with a path and an .so extension when the loaded file has a .so extension" do
      expect(the_probe.required_file("../a-file.so", ["/some/path/wrong-file.rb", "/some/path/a-file.so"])).
        to eq("/some/path/a-file.so")
    end

    it "finds the last file loaded" do
      expect(the_probe.required_file("a-file", ["/some/path/a-file.rb", "/some/other/path/a-file.rb"])).
        to eq("/some/other/path/a-file.rb")
    end
  end
end
