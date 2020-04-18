require './src/ruby_explorer'

describe "RubyExplorer#run" do
  let(:app) { RubyExplorer.new }
  let(:target_directory) {"target_directory"}
  let(:original_directory) {"original-directory"}

  before do
    allow(Dir).to receive(:chdir)
    allow(Process).to receive(:spawn)
    allow(Dir).to receive(:getwd).and_return(original_directory)

    app.target_directory= target_directory
    app.run
  end

  it "spawns the target app" do
    expect(Dir).to have_received(:chdir).with(target_directory).ordered
    expect(Process).to have_received(:spawn).with("/bin/bash",
                                                  "-l",
                                                  "-c",
                                                  "ruby -r #{original_directory}/src/probe.rb bin/rails").ordered
  end
end
