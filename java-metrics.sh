#!/bin/bash

## Retrieves Java lines and number of source files across git revisions

revisions=$@
if [ -z "$revisions" ] ; then
    echo "Usage: $0 [list of revisions to profile]"
    exit 1
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

printf '% 20s % 8s % 4s\n' 'branch' 'lines' 'files'
printf '% 20s % 8s % 4s\n' '------' '-----' '-----'
for revision in $revisions ; do
    if ! git checkout $revision &> /dev/null ; then
        printf '% 20s %s\n' $revision "is not recognized"
        continue
    fi
    num_files=$(find . -name '*.java' | wc -l | awk '{print $1}')
    num_lines=$(find . -name '*.java' | xargs wc -l | tail -n 1 | awk '{print $1}')
    printf '% 20s % 8d % 5s\n' $revision $num_lines $num_files
done

git co $current_branch 2> /dev/null
