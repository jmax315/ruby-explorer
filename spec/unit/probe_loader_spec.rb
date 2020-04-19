require "./src/probe"

describe "load_probe.rb" do
  let(:the_probe) { Probe.new }

  before do
    allow(Probe).to receive(:new).and_return(the_probe)
    allow(the_probe).to receive(:install)

    load("./src/probe_loader.rb")
  end

  it "calls Probe#install" do
    expect(the_probe).to have_received(:install)
  end
end
