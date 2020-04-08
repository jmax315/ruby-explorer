def set_argv(new_value)
  Object.__send__(:remove_const, :ARGV)
  Object.const_set(:ARGV, new_value)
end

describe "The CLI" do
  let(:argv) { [] }

  before do
    $the_app= nil
    set_argv(argv)
    load("bin/ruby-explorer")
  end

  describe "with no arguments" do
    let(:argv) { [] }

    it "does not create the app" do
      expect($the_app).to be_nil
    end

    it "prints a usage message to stderr"
  end

  describe "with a single argument" do
    let(:argv) { ["not-an-option"] }

    it "creates the app" do
      expect($the_app).not_to be_nil
    end
  end

  describe "with more than one argument" do
    let(:argv) { ["one-option", "another-option"] }

    it "does not create the app" do
      expect($the_app).to be_nil
    end
  end

  describe "with a short help option" do
    let(:argv) { ["-h"] }

    it "does not create the app" do
      expect($the_app).to be_nil
    end

    it "prints a usage message to stderr"
  end
end
