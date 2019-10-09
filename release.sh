#!/bin/sh
release_notes_file='release-notes.md'
first_new_line=`git diff --color=always $release_notes_file | perl -wlne 'print $1 if /^\e\[32m\+\e\[m\e\[32m(.*)\e\[m$/' | head -n 1`
new_version=`echo "$first_new_line" | grep -oP "(?<=\s)v.*(?=\s)"`

if [ -z $new_version ]
then
 echo 'No version found'
 exit 1
fi
read -r -p "${1:-Are you sure to release "$new_version"? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo "Going to release $new_version":
            git fetch
            has_new_file=`git diff master origin/master --name-only | wc -l`
            if [ $has_new_file -eq 0 ]
            then
              echo 'No new commit from remote'
              exit 1
            fi
            echo 'true'
            git pull origin master
            git commit -m "$new_version" $release_notes_file
            git tag $new_version
            git push origin $new_version
            git push origin master

            true
            ;;
        *)
            false
            ;;
    esac