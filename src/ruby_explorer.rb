class RubyExplorer
  attr_accessor :target_directory

  def run
    original_directory= Dir.getwd
    Dir.chdir(target_directory)
    Process.spawn("/bin/bash", "-l", "-c", "ruby -r #{original_directory}/src/probe.rb bin/rails server")
  end
end
