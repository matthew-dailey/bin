#!/bin/bash

test=true
branch=''
action=''
while [[ $# > 0 ]] ; do
    key="$1"
    case $key in
        -a|--auto)
            test=false
            ;;
        -b|--branch)
            branch="$2"
            ;;
        *)
            action="$key"
            ;;
    esac
    shift
done

if [ -z "$branch" ] ; then
    echo "Must provide a branch name to squash against master"
    exit 1
fi

squash=$branch-squash

set -e
set -x
# make sure branch exists, fail if it doesn't
git checkout $branch

# make master up-to-date
git checkout master
git pull

# go to the branch, make a new branch for the squashed commits, then rebase onto master
git checkout $branch
git checkout -b $squash

if $test; then
    echo "Finished testing before rebase.  Check that everything is good, then perform"
    echo "git rebase -i master"
    exit 0
fi
git rebase -i master

number_of_commits=$(git rev-list master..$squash --count)
if [ $number_of_commits -ne 1 ] ; then
    echo "ERROR: Squashed branch ($squash) isn't small enough."
    echo "       Should have only 1 commit but have $number_of_commits between master and this branch"
    echo "       Fix with a manual 'git rebase -i master'"
    exit 10
fi
git checkout master
git merge $squash
echo "Time to push me up to origin :)"
git diff --name-status origin/master
