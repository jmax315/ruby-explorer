describe "The CLI" do
  describe "with no arguments" do
    before do
      $the_app= nil
      load("bin/ruby-explorer")
    end

    it "does not create the app" do
      expect($the_app).to be_nil
    end
  end

  describe "with a single non-option argument" do
    before do
      $the_app= nil
      load("bin/ruby-explorer")
    end

    it "creates the app" do
      skip
      expect($the_app).not_to be_nil
    end
  end
end
