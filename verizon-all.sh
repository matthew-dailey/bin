#!/bin/bash

## Does the whole PDF extraction/cropping process.  Only thing required is
## downloading the PDFs to ~/Downloads

if ! which process-verizon-bills.sh &> /dev/null ; then
    echo "This script requires process-verizon-bills.sh be on the path"
    exit 1
fi

DOWNLOAD_DIR="$HOME/Downloads"
VERIZON_DIR="$DOWNLOAD_DIR/verizon-bills"
COMPLETE_DIR="$VERIZON_DIR/complete"
mkdir -p $COMPLETE_DIR

verizon_paths=$(echo "$DOWNLOAD_DIR/"Verizon-*)
path_count=$(echo $verizon_paths | wc -w | xargs)

if [ "$path_count" != 2 ] ; then
    echo "Did not find exactly 2 Verizon bills in $DOWNLOAD_DIR.  Exiting"
    exit 1
fi

echo $verizon_paths
mv $verizon_paths $VERIZON_DIR/

# TODO: this does not detect if there were old bills in this directory
#       or if there are cropped pdfs in there
process-verizon-bills.sh -f $VERIZON_DIR/*FIOS*.pdf -w $VERIZON_DIR/*Wireless*.pdf

# move non-cropped (aka original) PDFs into the complete directory
non_cropped=$(ls "$VERIZON_DIR/"*.pdf | grep -v 'cropped.pdf')
mv $non_cropped $COMPLETE_DIR/
