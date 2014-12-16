#!/usr/bin/env ruby

r = File.read('/var/games/nethack/record')

XLATE = {
  'Hum' => 'Human',
  'Dwa' => 'Dwarf',
  'Gno' => 'Gnome',

  'Mal' => 'Male',
  'Fem' => 'Female',

  'Male' => 'he',
  'Female' => 'she',

  'Arc' => 'Archaeologist',
  'Bar' => 'Barbarian',
  'Cav' => 'Caveman',
  'Hea' => 'Healer',
  'Kni' => 'Knight',
  'Mon' => 'Monk',
  'Pri' => 'Priest',
  'Ran' => 'Ranger',
  'Rog' => 'Rogue',
  'Sam' => 'Samurai',
  'Tou' => 'Tourist',
  'Val' => 'Valkyrie',
  'Wiz' => 'Wizard'
}

lines = []
r.each_line do |line|
  fields = line.split

  score = fields[1]
  date = fields[9]
  date = "#{date[0..3]}-#{date[4..5]}-#{date[6..7]}"

  role = XLATE[fields[11]] || fields[11]
  race = XLATE[fields[12]] || fields[12]
  gender = XLATE[fields[13]] || fields[13]
  designation = "#{gender} #{race} #{role}"

  tombstone = fields[15..-1].join(' ')
  user = tombstone.split(',')[0]
  epitaph = tombstone.split(',')[1..-1].join(',')

  sentence = "<li>On #{date}, <b>#{user}</b>, a #{designation}, earned <b>#{score}</b> points before #{XLATE[gender]} was #{epitaph}</li>"
  lines << sentence
end

html = "
<!DOCTYPE html  PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
<html>
    <head>
        <title>Ctrl-C.club nethack scores</title>
        <link href=\"/screen.css\" type=\"text/css\" rel=\"stylesheet\" />
    </head>

    <body>
        <h2>$>^C</h2>
        <h1>Ctrl-C.club nethack scores</h1>

        <p>Some of our users are discovering nethack!  Here are their stories:</p>
	<ul>
	#{lines.join}
	</ul>
	<p class=\"footer\">Last updated #{`date`}<p>
    </body>
</html>
"

puts html
File.open('/root/root_html/nethack.html', 'w') { |file| file.write(html) }
