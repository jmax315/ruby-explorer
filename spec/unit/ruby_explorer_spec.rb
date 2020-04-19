require './src/ruby_explorer'

describe "RubyExplorer#run" do
  let(:app) { RubyExplorer.new }

  let(:target_directory) {"../target-directory"}
  let(:bin_directory) {"../ruby-explorer/bin"}
  let(:cli_binary_path) {"#{bin_directory}/ruby-explorer"}
  let(:absolute_bin_directory) {"/home/user/ruby-explorer/bin"}
  let(:absolute_src_directory) {"/home/user/ruby-explorer/src"}

  before do
    allow(Dir).to receive(:chdir)
    allow(Process).to receive(:spawn)
    allow(File).to receive(:expand_path).and_return(absolute_src_directory)

    $0= cli_binary_path
    app.target_directory= target_directory
    app.run
  end

  it "finds the absolute path of the src directory" do
    expect(File).to have_received(:expand_path).with("#{bin_directory}/../src")
  end

  it "changes to the the target directory" do
    expect(Dir).to have_received(:chdir).with(target_directory)
  end

  it "spawns the target app" do
    expected_ruby_command=
      "ruby -r #{absolute_src_directory}/probe_loader.rb bin/rails server"

    expect(Process).to have_received(:spawn).
                         with("/bin/bash",
                              "-l",
                              "-c",
                              expected_ruby_command)
  end

  it "picks off the src directory, changes directories, and spawns, in that order" do
    expect(File).to have_received(:expand_path).ordered
    expect(Dir).to have_received(:chdir).ordered
    expect(Process).to have_received(:spawn).ordered
  end
end
