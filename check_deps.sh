#!/usr/bin/env bash
#===================HEADER=============================|
#AUTHOR
# Jefferson 'Slackjeff' Rocha <root@slackjeff.com.br>
#
#Check deps on project SPLITTER.
#======================================================|

#======================VARS
name="SPLITTER"
red_fg="\e[31;1m"
white_fg="\e[37;1m"
end_fg="\e[m"

# List of all Deps
list_dep=(
  'tor'
  'privoxy'
  'haproxy'
  'proxychains'
  'expect'
)

# Check a Deps
clear # Clear my life haha
cat << EOF
##################################################################
| Checking all ${name} dependencies are present on your system. |
##################################################################

EOF

count='0'
for check in ${list_dep[@]}; do
   if type "$check" &>/dev/null; then
      echo -e "$check \t[${white_fg}OK${end_fg}]" | expand -t 15
   else
      echo -e "$check \t[${red_fg}NO${end_fg}]" | expand -t 15
      count=$(($count + 1))
   fi
done

# If have one "NO" show this msg.
if [ "$count" -ge '1' ]; then
   echo -e "\n---> ${red_fg}Hey, you need to install all dependencies to be able to use ${name}${end_fg}"
else
   echo -e "\n---> ${white_fg}All right champ!${end_fg}"
fi
