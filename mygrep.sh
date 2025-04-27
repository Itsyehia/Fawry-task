# mygrep.sh - A simple grep-like script that searches for a pattern in a file
# and supports case-insensitive matching, line numbers, and inverted matches.

#!/usr/bin/env bash

# prints how to use the script (help message).
print_usage() {
  cat <<EOF
Usage: $0 [OPTIONS] PATTERN FILE
Search for PATTERN in FILE (case-insensitive).

Options:
  -n          Show line numbers
  -v          Invert match (print non-matching lines)
  --help      Show this help message
EOF
  exit 1
}

# Handle If the first argument the user --help 
# then print the help message and exit .
if [[ "$1" == "--help" ]]; then
  print_usage
fi

# create 2 vars:
# nflag for the line numbs 
# vflag for the inverted match
nflag=false
vflag=false

# start loop to read the options
# set the flag to true if its v or n 
# else print error message
while getopts ":nv" opt; do
  case $opt in
    n) nflag=true ;;
    v) vflag=true ;;
    \?) echo "Error: invalid option -$OPTARG" >&2; print_usage ;;
  esac
done
shift $((OPTIND -1))

# Check if the correct number of arguments is provided
# If the user did not provide exactly two things, shows an error message
# and prints the usage message.
if [ $# -ne 2 ]; then
  echo "Error: wrong number of arguments" >&2
  print_usage
fi

# Assign the pattern and file arguments to variables
pattern=$1
file=$2

# Check if the file exists and is readable
# else print an error message and exit with a non-zero status
if [ ! -r "$file" ]; then
  echo "Error: cannot read file '$file'" >&2
  exit 2
fi

# nable case insensitive matching
shopt -s nocasematch

# counter to track the line nb while reading the file.
lineno=0

# read the file line by line
# IFS: preserves spaces and tabs.
# -r: prevents backslash escapes from being interpreted.
while IFS= read -r line; do

  #  ++ the line nb counter by 1 for each new line.
  ((lineno++))

  # Check if the current line contains the search pattern.
  if [[ $line == *"$pattern"* ]]; then
    match=true
  else
    match=false
  fi

  # Invert if -v
  if $vflag; then
    if $match; then match=false; else match=true; fi
  fi

  #  If the line should be printed
  if $match; then
    # If -n is set, print the line number and the line
    # Otherwise, just print the line
    if $nflag; then
      printf "%d:%s\n" "$lineno" "$line"
    else
      printf "%s\n" "$line"
    fi
  fi
done < "$file"



Screenshot 1 – dig failing with system DNS, succeeding with 8.8.8.8.

Screenshot 2 – Editing /etc/hosts or fixing DNS, then dig now succeeds.

Screenshot 3 – nc -zv internal.example.com 80 succeeds.

Screenshot 4 – Browser or curl -I http://internal.example.com returns 200 OK.

Screenshot 5 – ss -tlnp on the server shows the listener on 0.0.0.0:80.