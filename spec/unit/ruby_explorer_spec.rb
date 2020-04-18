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

  it "changes to the the target directory" do
    expect(Dir).to have_received(:chdir).with(target_directory)
  end

  it "spawns the target app" do
    expected_ruby_command=
      "ruby -r #{original_directory}/src/probe.rb bin/rails server"

    expect(Process).to have_received(:spawn).
                         with("/bin/bash",
                              "-l",
                              "-c",
                              expected_ruby_command)
  end

  it "changes directories before trying to spawn" do
    expect(Dir).to have_received(:chdir).ordered
    expect(Process).to have_received(:spawn).ordered
  end
end
