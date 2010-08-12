#! /usr/bin/env ruby
# this puts all of the files in the current directory into an array of strings
# and then iterates over them
Dir["#{Dir.pwd}/*"].each do |file|
  system "ln -nfs #{file} #{Dir.home}/.#{file.split('/').last}" unless file.split('/').last.include?('install-zsh')
end
