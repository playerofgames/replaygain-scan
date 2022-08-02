# Copyright 2011–2022 Martin Scott
# Distributed under the GNU General Public License v3

echo Replay Gain Scanner
echo Version 0.4
echo " "

if [ "$#" -eq 0 ]
then
	echo "Drag files or folders to this window to scan and tag."
	exit 0
fi

SCANDIR=`pwd`/tag-directory-contents.sh
SCANFILES=`pwd`/tag-files-with-rg.sh
METAFLAC=`pwd`/bin/metaflac
AACGAIN=`pwd`/bin/aacgain
RESCAN=n
export SCANFILES METAFLAC AACGAIN RESCAN

START=$(date +%s)

files=()
for x in "$@"
do
    if [ -d "$x" ]
    then
        find "$x" -type d -exec "$SCANDIR" '{}' \;
    else
        files=("${files[@]}" "$x")
    fi
done

if [ -n "$files" ]
then
    echo Scanning input files "[" ${#files[@]} " files ]"
    "$SCANFILES" "${files[@]}"
    echo
fi

END=$(date +%s)
DIFF=$(echo "$END - $START" | bc)
echo "*** Finished in $DIFF seconds ***"
