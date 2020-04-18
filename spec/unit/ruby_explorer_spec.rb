require './src/ruby_explorer'

describe "RubyExplorer#run" do
  let(:app) { RubyExplorer.new }
  let(:target_directory) {"target_directory"}

  before do
    allow(Dir).to receive(:chdir)
    allow(Process).to receive(:spawn)

    app.target_directory= target_directory
    app.run
  end

  it "spawns the probe inserter" do
    expect(Dir).to have_received(:chdir).with(target_directory).ordered
    expect(Process).to have_received(:spawn).with("/bin/bash",
                                                  "-l",
                                                  "-c",
                                                  "ruby -r probe bin/rails").ordered
  end
end
