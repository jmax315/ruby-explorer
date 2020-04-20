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
      attr_accessor :a_method_called

      def initialize
        @a_method_called= false
      end

      def a_method
        @a_method_called= true
      end
    end

    let(:wrap_target) { WrapTarget.new }

    before do
      @got_called_back= false
      the_probe.wrap(WrapTarget, :a_method) do |original_method|
        @got_called_back= true
        original_method.call
      end

      wrap_target.a_method
    end

    it "calls the wrap block back" do
      expect(@got_called_back).to be(true)
    end

    it "calls the original method" do
      expect(wrap_target.a_method_called).to be(true)
    end
  end

  describe "#wrap_class_method" do
    class WrapTarget
      @@a_class_method_called= false

      def self.a_method
        @@a_class_method_called= true
      end
    end

    before do
      @got_called_back= false
      the_probe.wrap_class_method(WrapTarget, :a_method) do |original_method|
        @got_called_back= true
        original_method.call
      end

      WrapTarget.a_method
    end

    it "calls the wrap block back" do
      expect(@got_called_back).to be(true)
    end

    it "calls the original method" do
      expect(WrapTarget.class_variable_get(:@@a_class_method_called)).to be(true)
    end
  end
end
