#!/usr/bin/env ruby

users = `ls /home`.split.reject{|x|x == 'admin'}

lines = users.map do |user|
  if (`ls /home/#{user}/public_html/`.size == 0)
    %Q{<li>~#{user}</li>}
  else
    %Q{<li><a href="/~#{user}">~#{user}</a></li>}
  end
end

asof = `date`
dfree = `df -h`.split("\n").map{|x| "<li>#{x.gsub(/\s/, '&nbsp;')}</li>"}.join
usage = `du --summarize /home/* | sort -nr`.split("\n").map{|x| "<li>#{x}</li>"}.join
activity = `last | grep -v oot | grep -v calam | grep -v admin | head -n 20`.split("\n").map{|x| "<li>#{x.gsub(/\s/, '&nbsp;')}</li>"}.join
last24h = `find /home -name public_html -mtime 0`.split("\n").map{|x| "<li>#{x}</li>"}.join
last24h = '<strong>None</strong>' if last24h.length < 1

html = %Q{
<!DOCTYPE html PUBLIC "XHTML 1.1" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
    <head>
        <title>System Information</title>
        <link href="/screen.css" type="text/css" rel="stylesheet" />
    </head>

    <body>
        <h2>$>^C</h2>

        <h1>As Of: #{asof}</h1>
        <h1>Uptime</h1>
	<p>#{`uptime`}</p>

        <h1>Sites Updated in the Last 24 Hours</h1>
	<ol>#{last24h}</ol>

        <h1>Disk Free</h1>
	<ul>#{dfree}</ul>

        <h1>Disk Usage</h1>
	<ol>#{usage}</ol>

        <h1>Recent Activity</h1>
	<ol>#{activity}</ol>
    </body>
</html>
}

puts html
File.open('/root/root_html/system.html', 'w') { |file| file.write(html) }
