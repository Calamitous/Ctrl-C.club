x=$(who | cut -d' ' -f1 )
y=$(ps aux | grep mosh | cut -d' ' -f1)
echo "Currently logged in users, including MOSH: "
echo -e "$x\n$y" |sort | uniq
