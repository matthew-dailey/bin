#!/bin/bash

## Takes the PDFs of Verizon Wireless and Verizon FiOS bills, and extracts the relevant pages
## for expensing the bill to your company.

function usage() {
    echo "Usage: $0 -f fios_pdf_path -w wireless_pdf_path"
}

HERE=$(dirname $0)
CACHE_DIR=$HERE/cache
MIRROR_ROOT=http://ftp.wayne.edu/apache/pdfbox/
VERSION=2.0.8
JAR_NAME=pdfbox-app-${VERSION}.jar
JAR=$CACHE_DIR/$JAR_NAME
EXPECTED_SHA1=2754fd5d15aeb4b0dd55aef3328e7e3f0eacbd3b

function get_jar() {
    if ! [ -e $JAR ] ; then
        local url="${MIRROR_ROOT}/${VERSION}/${JAR_NAME}"
        echo "Downloading ${url} jar to $JAR"
        mkdir -p $CACHE_DIR
        curl "${url}" -o $JAR
    fi
    local sha1=''
    if which shasum &> /dev/null ; then
        sha1=$(shasum $JAR | awk '{print $1}')
    else
        sha1=$(sha1sum $JAR | awk '{print $1}')
    fi
    if ! [ "$EXPECTED_SHA1" == "$sha1" ] ; then
        echo "ERROR: bad hash.  expected: $EXPECTED_SHA1 actual: $sha1"
        echo "       You may need to manually download $JAR_NAME and put into $JAR"
        return 10
    fi
}

set -e
get_jar

while [[ $# > 1 ]] ; do
    key="$1"

    case $key in
        -f|--fios)
            fios_file="$2"
            ;;
        -w|--wireless)
            wireless_file="$2"
    esac
    shift
done

if [ -z "$fios_file" ] ; then
    echo "Missing fios file"
    usage
    exit 50
fi
if [ -z "$wireless_file" ] ; then
    echo "Missing wireless file"
    usage
    exit 100
fi

# need pages 1,2,3 for FiOS
# need pages 1,2,3 for wireless
EXEC="java -jar $JAR PDFSplit"
$EXEC -startPage 1 -endPage 3 $fios_file
$EXEC -startPage 1 -endPage 1 $wireless_file

# get some file name pieces parsed out
fios_dirname=$(dirname $fios_file)
fios_filename=$(basename $fios_file)
fios_filename_noext=$(echo $fios_filename | perl -pe 's:\.pdf$::')
fios_cropped_name=$fios_filename_noext-cropped.pdf
fios_cropped_path=$fios_dirname/$fios_cropped_name

wireless_dirname=$(dirname $wireless_file)
wireless_filename=$(basename $wireless_file)
wireless_filename_noext=$(echo $wireless_filename | perl -pe 's:\.pdf$::')
wireless_cropped_name=$wireless_filename_noext-cropped.pdf
wireless_cropped_path=$wireless_dirname/$wireless_cropped_name

mv $fios_dirname/$fios_filename_noext-1.pdf $fios_cropped_path
mv $wireless_dirname/$wireless_filename_noext-1.pdf $wireless_cropped_path

echo "Created $fios_cropped_path and $wireless_cropped_path"
