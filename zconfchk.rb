#!/usr/bin/env ruby

zconfs = `find /home -name znc.conf`.split.sort

zconfs.each do |zconf|
  puts "#{zconf}:	#{File.size(zconf)}"
end

