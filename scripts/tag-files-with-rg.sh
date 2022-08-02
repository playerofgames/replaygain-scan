#!/bin/bash
# Copyright 2011 Martin Scott
# Distributed under the GNU General Public License v3

# tag-files-with-rg.sh
#
# Adds replay gain info to flac, aac or mp3 files passed in.
#
# Requires METAFLAC and AACGAIN environment variables
# which store paths to these applications.

flacarray=()
aacarray=()

# Partition audio files
for x in "$@"
do
    if [ -f "$x" ]
    then
        if [[ "$x" =~ \.([Mm][Pp]3|[Mm]4[Aa])$ ]]
        then
            aacarray=( "${aacarray[@]}" "$x" )
        elif [[ "$x" =~ \.[Ff][Ll][Aa][Cc]$ ]]
        then
            flacarray=( "${flacarray[@]}" "$x" )
        fi
    fi
done

# Process MP3 and M4A files
if [ -n "$aacarray" ]
then
    do_scan=$RESCAN
    quiet=y

    if [ "${#aacarray[@]}" -eq "1" ]
    then
        count_pattern='Recommended "Track" dB change'
    else
        count_pattern='Recommended "Album" dB change'
    fi

    if [ $do_scan != "y" ]
    then
        # Rescan everything if any tracks are missing gain, or have differing gains
        # If there is only one mp3, there will be no reported album gain
	    count=$("$AACGAIN" -s c "${aacarray[@]}" | grep -c "$count_pattern")
	    unique=$("$AACGAIN" -s c "${aacarray[@]}" | grep "$count_pattern" | uniq | wc -l)

        if [ $count -ne "${#aacarray[@]}" ] || [ $unique -ne "1" ]
        then
            do_scan=y
			if [ $count -gt "0" ]
			then
				echo "WARNING:" $count "files are already tagged."
				echo "In a re-scan, this may indicate that some files are causing problems for the scan."
			fi
        fi
    fi

    if [ $do_scan == "y" ]
    then
        echo -n "[ new scan ] "
		"$AACGAIN" -s r -q "${aacarray[@]}" | sed -n "s/${count_pattern}.*: \(.*\)/Album gain: \1 dB/p"

        # Double-check the count
	    count=$("$AACGAIN" -s c "${aacarray[@]}" | grep -c "$count_pattern")
        if [ $count -ne "${#aacarray[@]}" ]
        then
            echo "ERROR: not all files were successfully tagged."
        fi

    else
        echo -n "[ already tagged ] "
        "$AACGAIN" -s c "${aacarray[@]}" | sed -n "s/${count_pattern}.*: \(.*\)/Album gain: \1 dB/p" | uniq
    fi
fi

# Process FLAC files
if [ -n "$flacarray" ]
then
    do_scan=$RESCAN

    if [ $do_scan != "y" ]
    then
        # Rescan everything if any tracks are missing gain, or have differing gains
        count=$("$METAFLAC" --show-tag=REPLAYGAIN_ALBUM_GAIN 2>/dev/null "${flacarray[@]}" | wc -l)
        unique=$("$METAFLAC" --show-tag=REPLAYGAIN_ALBUM_GAIN 2>/dev/null "${flacarray[@]}" | sed 's/.*REPLAYGAIN_ALBUM_GAIN=\(.*\) dB/\1/' | uniq | wc -l)

        if [ $count -ne "${#flacarray[@]}" ] || [ $unique -ne "1" ]
        then
			do_scan=y
        else
            echo -n "[ already tagged ] "
        fi
    fi

    if [ $do_scan == "y" ]
    then
        echo -n "[ new scan ] "
        "$METAFLAC" --add-replay-gain "${flacarray[@]}"

        # Double-check the count
        count=$("$METAFLAC" --show-tag=REPLAYGAIN_ALBUM_GAIN 2>/dev/null "${flacarray[@]}" | wc -l)
        if [ $count -ne "${#flacarray[@]}" ]
        then
            echo "ERROR: not all files were successfully tagged."
        fi
	fi
    "$METAFLAC" --show-tag=REPLAYGAIN_ALBUM_GAIN 2>/dev/null "${flacarray[0]}" | sed 's/REPLAYGAIN_ALBUM_GAIN=\(.*\) dB/Album gain: \1 dB/'
fi
