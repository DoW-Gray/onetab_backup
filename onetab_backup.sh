#!/bin/sh

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
