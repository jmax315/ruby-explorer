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
      attr_accessor :arg_passed

      def initialize
        @arg_passed= nil
      end

      def a_method(an_arg)
        @arg_passed= an_arg
      end
    end

    let(:wrap_target) { WrapTarget.new }

    before do
      @got_called_back= false
      the_probe.wrap(WrapTarget, :a_method) do |original_method, args|
        @got_called_back= true
        original_method.call(*args)
      end

      wrap_target.a_method("passed argument")
    end

    it "calls the wrap block back" do
      expect(@got_called_back).to be(true)
    end

    it "calls the original method" do
      expect(wrap_target.arg_passed).to eq("passed argument")
    end
  end

  describe "#wrap_class_method" do
    describe "with a class method" do
      class WrapTarget
        @@arg_passed= nil

        def self.a_class_method(an_arg)
          @@arg_passed= an_arg
        end
      end

      before do
        @got_called_back= false
        the_probe.wrap_class_method(WrapTarget, :a_class_method) do |original_method, args|
          @got_called_back= true
          original_method.call(*args)
        end

        WrapTarget.a_class_method("passed argument")
      end

      it "calls the wrap block back" do
        expect(@got_called_back).to be(true)
      end

      it "calls the original method with the original arguments" do
        expect(WrapTarget.class_variable_get(:@@arg_passed)).to eq("passed argument")
      end
    end

    describe "with a module method" do
      module ModuleToWrap
        @@arg_passed= nil

        def self.a_module_method(an_arg)
          @@arg_passed= an_arg
        end
      end

      before do
        @got_called_back= false
        the_probe.wrap_class_method(ModuleToWrap, :a_module_method) do |original_method, args|
          @got_called_back= true
          original_method.call(*args)
        end

        ModuleToWrap.a_module_method("passed argument")
      end

      it "calls the wrap block back" do
        expect(@got_called_back).to be(true)
      end

      it "calls the original method with the original arguments" do
        expect(ModuleToWrap.class_variable_get(:@@arg_passed)).to eq("passed argument")
      end
    end
  end
end
