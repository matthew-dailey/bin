#!/bin/bash

## This script is used to automate my git workflow for committing to master
##   All work is done on a branch
##   After the branch has been peer reviewed, rebase it onto master as one commit.
##    From branch, make $branch-squashed.
##    Rebase $branch-squashed onto master, and squash down to one commit
##   Merge the single commit in $branch-squashed onto master (as a fast-forward)
##   Rename the un-squashed branch to merged-$branch to "archive" it

function usage() {
    echo "Usage: $0: -b branchName [-d] [-r]"
    echo
    echo 'By default, this will update master, rebase branch onto master and squash commits, merge'
    echo 'branch into master (if only one commit after rebase), then rename branch to merged-$branch'
    echo '  -b branchName - the branch you want to merge onto master'
    echo '  -d|--debug - debug: will `set -x` and print out all commands run'
    echo '  -r|--rename - will rename branch to "merged-$branch"'
}

branch=''
debug=false
action='all'
while [[ $# > 0 ]] ; do
    key="$1"
    case $key in
        -b|--branch)
            branch="$2"
            ;;
        -d|--debug)
            debug=true
            ;;
        -r|--rename)
            action=rename
            ;;
    esac
    shift
done

if [ -z "$branch" ] ; then
    echo "Must provide a branch name to squash against master"
    usage
    exit 1
fi

squash=$branch-squash

set -e
$debug && set -x
function rebase_onto_master() {
    # make sure branch exists, fail if it doesn't
    git checkout $branch

    # make master up-to-date
    git checkout master
    git pull

    # go to the branch, make a new branch for the squashed commits, then rebase onto master
    git checkout $branch
    git checkout -b $squash
    git rebase -i master
}

function merge_to_master() {
    number_of_commits=$(git rev-list master..$squash --count)
    if [ $number_of_commits -ne 1 ] ; then
        echo "ERROR: Squashed branch ($squash) isn't small enough."
        echo "       Should have only 1 commit but have $number_of_commits between master and this branch"
        echo "       Fix with a manual 'git rebase -i master'"
        return 10
    fi
    git checkout master
    git merge $squash

    # should be able to use -d since everything was merged into master
    git branch -d $squash
}

function rename_merged_branch() {
    if [ "$branch" == "master" ] ; then
        echo "Sorry, I won't rename the master branch"
        return 20
    elif $(echo "$branch" | grep '^merged' &> /dev/null) ; then
        echo "Pretty sure branch $branch is already renamed, so not renaming it"
        return 21
    fi
    git branch -m "$branch" "merged-$branch"
}

if [ "$action" == 'all' ] ; then
    echo "Running the whole process"
    rebase_onto_master
    merge_to_master
    rename_merged_branch
    echo "Time to push master"
    git diff --name-status origin/master
elif [ "$action" == 'rename' ] ; then
    echo "Just renaming branch"
    rename_merged_branch
fi
