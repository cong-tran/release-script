#!/bin/sh
release_notes_file='release-notes.md'
first_new_line=`git diff --color=always $release_notes_file | perl -wlne 'print $1 if /^\e\[32m\+\e\[m\e\[32m(.*)\e\[m$/' | head -n 1`
new_version=`echo "$first_new_line" | grep -oP "(?<=\s)v.*(?=\s)"`

read -r -p "${1:-Are you sure to release "$new_version"? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo 'Releasing $new_version':
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