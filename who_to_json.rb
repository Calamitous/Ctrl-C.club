#!/usr/bin/env ruby
require 'nokogiri'

users = `ls /home`.split.reject{|x|x == 'admin'}

lines = users.map do |user|
  index = "/home/#{user}/public_html/index.html"
  title = nil
  mtime = nil

  if FileTest.exists?(index)
    File.open(index, 'r') { |f| title = Nokogiri::HTML(f).css('html head title').text }
    title = title.gsub(/\n/, '').gsub(/	/, ' ').gsub(/"/, "'")
    mtime = File.mtime(index).strftime('%s').to_i
    humanized_time = File.mtime(index)
    %Q{{"username": "#{user}", "title": "#{title}", "mtime": #{mtime}, "humanized_time": "#{humanized_time}"}}
  else
    %Q{{"username": "#{user}", "title": null, "mtime": null}}
  end

end

json = %Q{
{
    "name": "Ctrl-C.club",
    "url": "http://ctrl-c.club",
    "signup_url": "http://goo.gl/forms/oviL1wYSrV",
    "user_count": #{lines.size},
    "want_users": true,
    "admin_email": "admin@ctrl-c.club",
    "description": "A place for the curious to poke around and play. SSH access, web pages, games, and programming languages on tap.",
    "users": [ #{lines.join(', ')} ]
}
}

puts
puts "#{lines.size} users written to JSON"
puts


File.open('/root/site/tilde.json', 'w') { |file| file.write(json) }
