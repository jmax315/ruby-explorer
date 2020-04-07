describe "The CLI" do
  before do
    $the_app= nil
    load("bin/ruby-explorer")
  end

  it "creates the app" do
    expect($the_app).not_to be_nil
  end
end
