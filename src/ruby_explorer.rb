class RubyExplorer
  attr_accessor :target_directory

  def run
    Process.spawn("/bin/bash", "-l", "-c", "ruby -r probe bin/rails")
  end
end
