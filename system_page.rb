#!/usr/bin/env ruby

users = `ls /home`.split.reject{|x|x == 'admin'}

`~/bin/who_to_json.rb`
lines = users.map do |user|
  if (`ls /home/#{user}/public_html/`.size == 0)
    %Q{<li>~#{user}</li>}
  else
    %Q{<li><a href="/~#{user}">~#{user}</a></li>}
  end
end

def htmlize_lines(result)
  result.split("\n").map{|x| "<li>#{x.gsub(/\s/, '&nbsp;')}</li>"}.join
end

asof       = `date`
dfree      = htmlize_lines(`df -h`)
usage      = htmlize_lines(`du --summarize /home/* | sort -nr`).gsub(/dsc/, "dsc <em>- OK TO GO OVER</em>").gsub(/nomius/, "nomius <em>- OK TO GO OVER</em>")
activity   = htmlize_lines(`last | grep -v oot | grep -v calam | grep -v admin | head -n 20`)
last24h    = htmlize_lines(`find /home -name public_html -mtime 0`)
last24h    = '<strong>None</strong>' if last24h.length < 1
# banned_ips = htmlize_lines(`cat /etc/fail2ban/ip.blacklist`)

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

        <h1>Sites Updated or Created in the Last 24 Hours</h1>
	<ol>#{last24h}</ol>

        <h1>Disk Free</h1>
	<ul>#{dfree}</ul>

        <h1>Disk Usage</h1>
	<ol>#{usage}</ol>

        <h1>Recent Activity</h1>
	<ol>#{activity}</ol>

        <h1>Banned IPs</h1>
	<ol>See: /etc/fail2ban/ip.blacklist</ol>
    </body>
</html>
}

puts html
File.open('/root/site/system.html', 'w') { |file| file.write(html) }
