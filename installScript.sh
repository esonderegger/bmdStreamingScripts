#!/usr/bin/env bash

# many thanks to revmischa, as this is adapted from his gist:
# https://gist.github.com/revmischa/742831
 
# This script fetches and builds libx264, libav, rtmpd and their dependencies.
# you may have to add /usr/local/lib to /etc/ld.so.conf
 
# BASEDIR = build directory (default current dir)
# PREFIX = install directory (default /usr/local)
if [ -z "$BASEDIR" ]; then
BASEDIR=`pwd`
fi
 
if [ -z "$PREFIX" ]; then
PREFIX="/usr/local"
fi
 
# install some deps
sudo apt-get install libmp3lame-dev libfaac-dev build-essential git cmake subversion libtinyxml-dev \
liblua50-dev libvorbis-dev libssl-dev unzip || exit 1

# install DeckLink drivers
cd $BASEDIR
wget http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_9.8.tar.gz
mkdir Blackmagic_Desktop_Video_Linux_9.8
tar -xvf Blackmagic_Desktop_Video_Linux_9.8.tar.gz -C Blackmagic_Desktop_Video_Linux_9.8
cd Blackmagic_Desktop_Video_Linux_9.8
sudo dpkg -i desktopvideo-9.8-i386.deb
# dpkg doesn't install dependencies, but this command fixes it:
sudo apt-get -f install

# grab YASM
cd $BASEDIR
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar -xvf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix=$PREFIX && make && sudo make install
 
# grab librtmp
cd $BASEDIR
git clone git://git.ffmpeg.org/rtmpdump rtmpdump
cd rtmpdump
make && sudo make install
 
# grab libfaac (currently broken)
cd $BASEDIR
wget http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2
tar -xvf faac-1.28.tar.bz2
cd faac-1.28
./configure --prefix=$PREFIX && make && sudo make install
 
# fetch latest libx264 and build (ignoring installed libav)
cd $BASEDIR
echo "Fetching x264..."
git clone git://git.videolan.org/x264.git
cd x264
echo "Building x264 without libav..."
./configure --prefix=$PREFIX --enable-pic --enable-shared --disable-lavf && make && sudo make install
 
# fetch libav and install
echo "Fetching libav..."
cd $BASEDIR
#wget http://libav.org/releases/libav-0.8.tar.gz
#tar -zxf libav-0.8.tar.gz
git clone git://git.libav.org/libav.git libav
#cd libav-0.8
cd libav
echo "Building libav..."
sudo ldconfig
./configure --prefix=$PREFIX \
--enable-libmp3lame --enable-librtmp --enable-libx264 \
--enable-libfaac --enable-libvorbis \
--enable-pic --enable-shared \
--enable-gpl --enable-nonfree \
&& make && sudo make install && echo "libav installed"
 
sudo ldconfig
 
# now we must rebuild libx264 with our version of libav
cd $BASEDIR/x264
echo "Building x264 with libav..."
./configure --prefix=$PREFIX --enable-pic --enable-shared && make && sudo make install && echo "libx264 installed"

# download and unzip DeckLink SDK
cd $BASEDIR
wget http://software.blackmagicdesign.com/SDK/Blackmagic_DeckLink_SDK_9.7.7.zip
unzip Blackmagic_DeckLink_SDK_9.7.7.zip
mv "Blackmagic DeckLink SDK 9.7.7" Blackmagic_DeckLink_SDK_9.7.7

# download and make bmdtools
cd $BASEDIR
git clone https://github.com/lu-zero/bmdtools.git bmdtools
cd bmdtools
make SDK_PATH=$BASEDIR/Blackmagic_DeckLink_SDK_9.7.7/Linux/include
