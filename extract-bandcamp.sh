#!/bin/bash

## bandcamp.com lets you download music in zip files with spaces in the names.  This script
## will unzip the file into an appropriately named directory in ~/Music

UNZIP=$(type -p unzip)
if [ -z "$UNZIP" ] ; then
    echo "Install an 'unzip' utility to use $0"
    exit 1
fi

set -e

inzip="$1"
if [ -z "$inzip" ] ; then
    echo "Usage: $0 \"downloaded_zip_path\""
    echo "  e.g. $0 \"Downloads/HyperDuck SoundWorks - Dust- An Elysian Tail - Original Soundtrack.zip\""
    exit 5
fi

mkdir -p "$HOME/Music"

outdirname=$(basename "$inzip" | sed 's/.zip$//')
outpath="$HOME/Music/$outdirname"
mkdir -p "$outpath"
"$UNZIP" -d "$outpath" "$inzip"
