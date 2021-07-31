#!/bin/bash
pwgen
adduser --force-badname $1 &&
	chmod a+rx /home/$1 &&
	mkdir /home/$1/public_html &&
	mkdir /home/$1/.ssh &&
	touch /home/$1/.ssh/authorized_keys &&
	chown -R $1:$1 /home/$1 &&
	make_mail.sh $1 &&
	mkdir /var/gemini/users/$1 &&
	chown $1:$1 /var/gemini/users/$1 &&
	ln -s /var/gemini/users/$1 /home/$1/public_gemini &&
	chown $1:$1 /home/$1/public_gemini

who_to_html.rb
who_to_json.rb
