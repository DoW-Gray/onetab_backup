#!/bin/sh

#   onetab_backup.sh - back up Onetab data for Firefox on Linux
#   Copyright (C) 2018  Patrick Gray

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

fname="/home/$(whoami)/.mozilla/firefox/$(ls ~/.mozilla/firefox | grep '\.default')/browser-extension-data/extension@one-tab.com/storage.js"

save_dir="/home/$(whoami)/Documents/onetabs/" # modify this directory as you please
mkdir -p "$save_dir"

cat $fname | sed -Ee 's/\{\\\"createDate\\\":([0-9]{3,20}),\\\"tabsMeta\\\":\[/\n\1/g' \
    | tail -n +3 \
    | python3 -c "import sys, re; [print(('0' * (20 - len(re.findall(r'\d+', i)[0])) + i) or '') for i in sys.stdin.read().split('\n')]" \
    | sort -r \
    | sed -Ee 's/^[0-9]{20}/\n/' \
    | perl -pe 's/,?\{\\\"id\\\":\\\"[a-zA-Z0-9_-]+\\\",\\\"url\\\":\\\"(.*?)\\\",\\\"title\\\":\\\"(.*?)\\\"}/\1 | \2\n/g' \
    | perl -pe 's/.*?\\\"id\\\":\\\"[a-zA-Z0-9_-]+\\\",\\\"tabsMeta\\\":\[(.+)/\n\1/g' \
    | egrep -v '^\],\\\"id\\\":\\\"[a-zA-Z0-9_-]+\\\"\},$' \
    | grep -v createDate \
    > "$save_dir/$(date -I'seconds')"
