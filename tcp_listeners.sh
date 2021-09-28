netstat -tulpn | sed "s/\.\///" | grep "^tcp" | grep -v "nginx:" | awk -F'/' '{ print $1, $2}' | awk '{ printf("%10s %20s %-10s %25s\n", $7, $8, $9, $4); }' | sort -n
