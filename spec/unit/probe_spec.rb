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
  end

  describe "#wrap_class_method" do
    class WrapClassMethodTarget
      @@a_class_method_called= false
      @@arg_value= nil

      def self.a_method(arg)
        @@a_class_method_called= true
        @@arg_value= arg
      end
    end

    before do
      @got_called_back= false
      the_probe.wrap_class_method(WrapClassMethodTarget, :a_method) do |original_method, args|
        @got_called_back= true
        original_method.call(*args)
      end

      WrapClassMethodTarget.a_method("expected arg value")
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
  end

  describe "#wrap on a module method" do
    module WrapModule
      def a_module_method(arg)
        @a_module_method_called= true
        @arg_value= arg
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
  end
end
