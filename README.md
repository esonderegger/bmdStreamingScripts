bmdStreamingScripts
===================

Scripts for streaming from a Blackmagic DeckLink card to YouTube Live

These are some scripts I use for streaming to YouTube with a Blackmagic DeckLink SDI capture card.
They have been tested with Ubuntu Server 13.10.
Many thanks to [lu-zero](https://github.com/lu-zero) for his [bmdtools](https://github.com/lu-zero/bmdtools) and
to [revmischa](https://github.com/revmischa) for his [build-video-server gist](https://gist.github.com/revmischa/742831).

After installing Ubuntu, edit /etc/ld.so.conf by adding /usr/local/lib at the end and run 'sudo ldconfig'.
Then install the necessary software by running installScript.sh and copy encodeScript.sh to the bmdtools directory.

## Usage

From the bmdtools directory:
./encodeScript.sh youtube-stream-name

Please let me know if these are useful for you or if there's anything I should change. Thanks!
