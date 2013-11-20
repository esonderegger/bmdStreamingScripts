#!/usr/bin/env bash
# This script captures 720p video from a Blackmagic DeckLink SDI card
# then encodes that video using avconv, streaming the result to YouTube Live
# The first parameter passed to the script should be the stream name as provided by YouTube
# Every now and then, this script runs into "failed to update header..." errors, so
# the loop restarts the stream.

while :
do
./bmdcapture -m 12 -A 2 -F nut -f pipe:1 | avconv -y -i - -r 30000/1001 -s 1280x720 -pix_fmt yuv420p -vcodec libx264 -vb 3000k -g 50 -acodec libfaac -ab 160k -f flv rtmp://a.rtmp.youtube.com/live2/$1

echo "There was a problem encoding at $(date)" >> $1.txt
done
