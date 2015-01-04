touch /var/mail/$1 &&
	chown $1:mail /var/mail/$1 &&
	chmod o-r /var/mail/$1 &&
	chmod g+rw /var/mail/$1
