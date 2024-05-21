#! /usr/bin/env ruby
# this puts all of the files in the current directory into an array of strings
# and then iterates over them

ignore = ["README", "install-zsh-environment.rb"] # Don't symlink these
home = ENV['HOME']
Dir["#{Dir.pwd}/*"].each do |file|
  filename = file.split('/').last
  system "ln -nfs #{file} #{home}/.#{filename}" unless ignore.include? filename
end
