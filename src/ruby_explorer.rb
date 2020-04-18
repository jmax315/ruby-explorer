class RubyExplorer
  attr_accessor :target_directory

  def run
    Dir.chdir(target_directory)
    Process.spawn("/bin/bash", "-l", "-c", "ruby -r probe bin/rails")
  end
end
