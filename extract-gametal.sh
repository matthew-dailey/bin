#!/bin/bash

## Extracts GaMetal audio from zip files into the Music directory
## music downloads from http://www.jonnyatma.com/gametal/news.html

destination="$HOME/Music/GaMetal"
mkdir -p "$destination"

for zipfile in ~/Downloads/GaMetal*; do
    # if there are no files, $zipfile will just be "~/Downloads/GaMetal*" which doesn't exist
    if [ -f "$zipfile" ] ; then
        unzip "$zipfile" -d "$destination"
    fi
done
