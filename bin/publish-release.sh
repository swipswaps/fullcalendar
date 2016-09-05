#!/usr/bin/env bash

# always immediately exit upon error
set -e

# start in project root
cd "`dirname $0`/.."

./bin/require-clean-working-tree.sh

read -p "Enter the version you want to publish, with no 'v' (for example '1.0.1'): " version
if [[ ! "$version" ]]
then
	echo "Aborting."
	exit 1
fi

# push the current branch (assumes tracking is set up) and the tag
git push
git push origin "v$version"

# save reference to current branch
current_branch=$(git symbolic-ref --quiet --short HEAD)

success=0

# temporarily checkout the tag's commit, publish to NPM
git checkout --quiet "v$version"
if npm publish
then
	success=1
fi

# return to branch
git checkout --quiet "$current_branch"

if [[ "$success" = "1" ]]
then
	echo "Success."
else
	echo "Failure."
	exit 1
fi
