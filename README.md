# onetab_backup
##### Shell script for backing up onetab data for Firefox on Linux

The [onetab](https://addons.mozilla.org/en-GB/firefox/addon/onetab/) extension for Firefox is very useful, storing all old tabs that you may wish to revisit. However, whenever it updates all this data is lost. It can be exported and imported fairly easily from Firefox, but this requires manual work and remembering to do this.

This script provides a simple solution, by finding the locally stored file that corresponds to the onetab data, and converting it to the correct format to be imported. Now you can just add a line like this to your [crontab](https://linux.die.net/man/1/crontab):

```0 1 * * 0 /location/of/this/git/onetab_backup.sh```

Then when onetab updates and all your data is lost, simply look for the most recent timestamp in your ``~/Documents/onetabs/`` directory, and import this.

Requires:
* python3
* perl

Bugs:
* The tab groups may not be in the same order as they were originally.
