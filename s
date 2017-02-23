#!/usr/bin/env bash

# This file should assign the users phone number to "$user" and declare and populate two
# associative arrays: `contacts` and `groups`.
source "${XDG_CONFIG_HOME:-$HOME/.config}/signal/init.bash"

[[ ! $signal_cli ]] && signal_cli='signal-cli'

show-help() {
cat << EOF
Usage: ${0##*/} [-s] [RECIPIENT [RECIPIENT]...] [MESSAGE]
Send MESSAGE to one more recipients using signal-cli.  Requires that
signal-cli is running in daemon mode providing the D-Bus interface.
When MESSAGE is omitted, read from stdin.  See signal-cli(1).

  -h  display this help and exit
  -s  query for a region or window to take a screenshot of and send it;
      can be used multiple times to take several screenshots (this
      doesn't currently work); requires maim(1) and slop
  -d  print debugging output
EOF
}

# Declare as integers.
declare -i screenshot=0 debug=0

# http://mywiki.wooledge.org/BashFAQ/035#getopts
# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ':hsd' opt; do
   case $opt in
      h)
         show-help
         exit
         ;;
      s)
         (( ++screenshot ))
         ;;
      d)
         (( ++debug ))
         ;;
      \?)
         echo "Invalid option: -$OPTARG" >&2
         show-help >&2
         exit 1
         ;;
   esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

signal() {
   if (( debug )); then
      (set -x; "$signal_cli" --dbus "$@")
   else
      "$signal_cli" --dbus "$@"
   fi
   # TODO: allow sending messages when the signal-cli daemon isn't running.
   # "$signal_cli" -u "$user" "$@"
}

recipients=()
group=
while (( $# >= 1 )); do # While there are more positional parameters...
   if [[ ${contacts[$1]} ]]; then
      recipients+=(${contacts[$1]})
      # Shift the positional parameters, so $1 is assigned $2 and so on.
      shift
   elif [[ ${groups[$1]} ]]; then
      if [[ $group ]]; then
         # I think we cannot send to multiple groups at the same time.  Is this a
         # limitation of signal-cli or the server?  TODO?
         echo "Can't send to multiple groups at the same time." >&2
         exit 1
      fi
      group="${groups[$1]}"
      shift
   else
      # Treat the remaining positional parameters as the message.
      break
   fi
done

if [[ $group ]]; then
   if (( ${#recipients[@]} > 0 )); then
      # Seems we can't send a message to individual recipients by phone number and a group
      # at the same time.  TODO?
      echo "Can't send to individual recipients and a group at the same time." >&2
      exit 1
   fi
   recipients=('-g' "$group")
fi

if (( ${#recipients[@]} == 0 )); then
   echo "No known recipients." >&2
   exit 1
fi

# Arithmetic expressions evaluate to logical "true" when they are not 0.
if (( screenshot )); then
   if [[ ! $group && (( ${#recipients[@]} > 1)) ]]; then
      # We can't send a screenshot to multiple recipients at the same time.  Could this be
      # an upstream issue?  TODO?
      echo "Sending a screenshot to multiple recipients is not supported." >&2
      exit 1
   fi
   # Sending multiple screenshots when the `-s` option was specified more than once does
   # not work.  This might be a limitation of the Signal server: the Android client can't
   # send multiple attachments in one message either.
   attachments=()
   while (( screenshot-- )); do
      # Prompt for a window or area to take a screenshot of and send it via signal-cli.
      f=$(mktemp --suffix='.png')
      maim -s -b 2 -c .843,.373,.373 --nokeyboard "$f" || maim "$f" || exit 1
      attachments+=("$f")
   done
   # Don't require a message; i.e., don't wait for stdin.  "$*" can be empty.
   signal send -m "$*" "${recipients[@]}" -a "${attachments[@]}"
   rm "${attachments[@]}"
elif (( $# == 0 )); then
   # Read the message from stdin.
   signal send "${recipients[@]}"
else
   signal send -m "$*" "${recipients[@]}"
fi

# vim: tw=90 sts=-1 sw=3 et
