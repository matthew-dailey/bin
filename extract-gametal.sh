#!/bin/bash

## Extracts GaMetal audio from zip files into the Music directory
## music downloads from http://www.jonnyatma.com/gametal/news.html

delete=''

if [[ "$1" == "-d" ]] || [[ "$1" == "--delete" ]]; then
  delete=true
fi

destination="$HOME/Music/GaMetal"
mkdir -p "$destination"

for zipfile in ~/Downloads/GaMetal*; do
    # if there are no files, $zipfile will just be "~/Downloads/GaMetal*" which doesn't exist
    if [ -f "$zipfile" ] ; then
        unzip "$zipfile" -d "$destination"
        if [[ "$delete" == "true" ]] ; then
            echo "deleting $zipfile"
            rm "$zipfile"
        fi
    fi
done
