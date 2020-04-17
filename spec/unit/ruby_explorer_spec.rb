require './src/ruby_explorer'

describe "RubyExplorer#run" do
  let(:app) { RubyExplorer.new }

  before do
    allow(Process).to receive(:spawn)
    app.run
  end

  it "spawns the probe inserter" do
    expect(Process).to have_received(:spawn).with("/bin/bash",
                                                  "-l",
                                                  "-c",
                                                  "ruby -r probe bin/rails")

  end
end
