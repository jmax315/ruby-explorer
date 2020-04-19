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
  end
end
