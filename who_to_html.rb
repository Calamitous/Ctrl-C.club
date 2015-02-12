#!/usr/bin/env ruby

users = `ls /home`.split.reject{|x|x == 'admin'}

lines = users.map do |user|
  if (`ls /home/#{user}/public_html/`.size == 0)
    %Q{<li>~#{user}</li>}
  else
    %Q{<li><a href="/~#{user}">~#{user}</a></li>}
  end
end

html = %Q{
<!DOCTYPE html PUBLIC "XHTML 1.1" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
    <head>
        <title>Who's a part of Ctrl-C Club?</title>
        <link href="/screen.css" type="text/css" rel="stylesheet" />
    </head>

    <body>
        <h2>$>^C</h2>
        <h1>Who's a part of Ctrl-C Club?</h1>
        <ol class="user-list">
	#{lines.join}
        </ol>

        <h1>&nbsp;</h1>
        <p class="footer">Send suggestions and questions to <a href="mailto:admin@ctrl-c.club">admin@ctrl-c.club</a></p>
        <p class="footer">Thank you to everyone who's a part of this crazy experiment!</p>
    </body>
</html>
}

puts html

sed = %Q{sed -i "s/Population: [0-9]\\+/Population: #{lines.size}/" /root/root_html/index.html}
puts sed
system sed

puts
puts "#{lines.size} users"
puts

File.open('/root/root_html/who.html', 'w') { |file| file.write(html) }
