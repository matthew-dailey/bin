#!/bin/bash

## Takes the PDFs of Verizon Wireless and Verizon FiOS bills, and extracts the relevant pages
## for getting expensing the bill to your company.

function usage() {
    echo "Usage: $0 -f fios_pdf_path -w wireless_pdf_path"
}

HERE=$(dirname $0)
CACHE_DIR=$HERE/cache
JAR_NAME=pdfbox-app-2.0.2.jar
JAR=$CACHE_DIR/$JAR_NAME
EXPECTED_SHA1=5478cf672489319bd4ccd635dd29f7478bf8b385

function get_jar() {
    if ! [ -e $JAR ] ; then
        echo "Downloading $JAR_NAME jar to $JAR"
        mkdir -p $CACHE_DIR
        curl http://www.motorlogy.com/apache/pdfbox/2.0.2/$JAR_NAME -o $JAR
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
$EXEC -startPage 1 -endPage 3 $wireless_file
