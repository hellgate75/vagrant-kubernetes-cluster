#!/bin/sh

ip=${1:-1.2.3.4}

if expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
  for i in 1 2 3 4; do
    if [ $(echo "$ip" | cut -d. -f$i) -gt 255 ]; then
      echo "fail ($ip)"
      exit 1
    fi
  done
  echo "success ($ip)"
  exit 0
else
  echo "fail ($ip)"
  exit 1
fi
