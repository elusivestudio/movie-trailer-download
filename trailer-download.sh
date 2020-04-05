#!/bin/bash
############################################################
# MOVIES_DIR is the root directory
# it contains sub directories with year names
# each year directory contains movie directory
# Movie Format: Movies/{y}/{n}/{n} {y} {hd} {hdr}
############################################################
# This script uses youtube-dl to download movie trailers
# (https://github.com/ytdl-org/youtube-dl)
# ----------------------------------------------------------

# Set movies root directory
MOVIES_DIR="/volume1/video/Movies/"

cd $MOVIES_DIR
directories=(*/)

for dir in "${directories[@]}"
do
	cd "$dir"
	echo `pwd`
	subDirectories=(*/)
	for subDir in "${subDirectories[@]}"
	do
		cd "$subDir"
		echo `pwd`
		
		subDirName=${subDir%*/}
		echo $subDirName
		# Download trailer
		if find . -iname '*trailer*' -printf 1 -quit | grep -q 1
		then
		    TRAILER_FILE_NAME=`find $subDirName -type f -iname "*trailer*"`
		    echo "Trailer found: ${TRAILER_FILE_NAME}"
		else
		    echo Trailer not found, downloading...
		    MOVIE_NAME=`find . -type f -regex '.*\.\(mp4\|mkv\|avi\)'`
		    MOVIE_NAME="${MOVIE_NAME##*/}"
		    echo "$MOVIE_NAME"
		    echo "${MOVIE_NAME%.*}"
		    /usr/local/bin/youtube-dl "ytsearch1: ${MOVIE_NAME%.*} trailer"
		    NEW_TRAILER_FILE=`find . -type f -iname "*trailer*"`
		    echo ${NEW_TRAILER_FILE##*/}
		    mv "${NEW_TRAILER_FILE##*/}" "${MOVIE_NAME%.*}-trailer.mkv"
		fi
		
		cd ..
	done
	cd ..
done
