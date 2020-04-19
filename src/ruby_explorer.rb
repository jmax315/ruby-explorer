require 'pathname'

class RubyExplorer
  attr_accessor :target_directory

  def run
    bin_directory= Pathname.new($0).dirname
    src_directory= File.expand_path("#{bin_directory}/../src")
    Dir.chdir(target_directory)
    Process.spawn("/bin/bash", "-l", "-c", "ruby -r #{src_directory}/probe_loader.rb bin/rails server")
  end
end
