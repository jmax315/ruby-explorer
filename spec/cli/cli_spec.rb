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
  end

  describe "with a single non-option argument" do
    let(:argv) { ["not-an-option"] }

    it "creates the app" do
      expect($the_app).not_to be_nil
    end
  end
end
