require './src/ruby_explorer'

describe "The CLI" do
  def set_argv(new_value)
    Object.__send__(:remove_const, :ARGV)
    Object.const_set(:ARGV, new_value)
  end

  def invoke_cli_with(argv)
    $the_app= nil
    @error_exit= nil
    @stderr_output= nil
    @saved_stderr= $stderr
    $stderr= StringIO.new

    set_argv(argv)
    begin
      load("bin/ruby-explorer")
    rescue SystemExit => e
      @error_exit= !e.success?
    end
    @stderr_output= $stderr.string
    $stderr= @saved_stderr
  end

  def self.expect_cli_to_fail_with(argv)
    before do
      invoke_cli_with(argv)
    end

    it "does not create the app" do
      expect($the_app).to be_nil
    end

    it "prints a usage message to stderr" do
      expect(@stderr_output).to match(/usage:/)
    end

    it "exits with an error status" do
      expect(@error_exit).to be(true)
    end
  end

  def self.expect_cli_to_succeed_with(argv)
    before do
      invoke_cli_with(argv)
    end

    it "creates the app" do
      expect($the_app).not_to be_nil
    end

    it "does not print anything to stderr" do
      expect(@stderr_output).to eq("")
    end

    it "exits with an success status" do
      expect(@error_exit).to be(false)
    end

    yield if block_given?
  end


  before do
    allow_any_instance_of(RubyExplorer).to receive(:run)
  end

  describe "with no arguments" do
    expect_cli_to_fail_with []
  end

  describe "with more than one argument" do
    expect_cli_to_fail_with ["one-option", "another-option"]
  end

  describe "with a short help option" do
    expect_cli_to_fail_with ["-h"]
  end

  describe "with a long help option" do
    expect_cli_to_fail_with ["--help"]
  end

  describe "with a single argument" do
    expect_cli_to_succeed_with ["not-an-option"] do
      it "sets the app's target directory" do
        expect($the_app.target_directory).to eq("not-an-option")
      end

      it "calls the app's run method" do
        expect($the_app).to have_received(:run)
      end
    end
  end
end
