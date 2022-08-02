#!/bin/bash
# Copyright 2011 Martin Scott
# Distributed under the GNU General Public License v3

# Requires SCANFILES environment variable which stores path to appropriate script.

# Check that the argument passed to this script is a directory.
# If it's not, then exit with an error code.

if [ ! -d "$1" ]
then
	echo "Arg "$1" is NOT a directory!"
	exit 10
fi

pushd "$1" >/dev/null

filecount=`ls -1 *.{[Ff][Ll][Aa][Cc],[Mm][Pp]3,[Mm]4[Aa]} 2>/dev/null | wc -l`

if [ $filecount -gt 0 ]
then
	echo In folder: \"`dirname "$1"`\"
	echo Scanning: \"`basename "$1"`\" "[" $filecount "files ]"
    "$SCANFILES" *.{[Ff][Ll][Aa][Cc],[Mm][Pp]3,[Mm]4[Aa]}
    echo
fi

popd >/dev/null
