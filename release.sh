#!/bin/sh
release_notes_file='release-notes.md'
first_new_line=$(git diff --color=always $release_notes_file | perl -wlne 'print $1 if /^\e\[32m\+\e\[m\e\[32m(.*)\e\[m$/' | head -n 1)
new_version=$(echo "$first_new_line" | grep -oP "(?<=\s)v.*(?=\s)")

if [ -z $new_version ]; then
  echo 'No version found'
  exit 1
fi

confirm() {
  read -p "$* [y/N]: " yn
  case $yn in
  [yY][eE][sS] | [yY]*) return 0 ;;
  *)
    echo "Aborted"
    return 1
    ;;
  esac
}

if confirm "Are you sure to release "$new_version""; then
  echo "Going to release $new_version":
  git fetch
  production_branch='master'
  has_new_file=$(git diff $production_branch origin/$production_branch --name-only | wc -l)
  if [ $has_new_file -eq 0 ]; then
    if confirm "No new commit from remote. Did you merge Pull Request? Confirm to continue"; then
      echo "Pull commit from $production_branch"
      git pull origin $production_branch
      echo "Commit version $new_version"
      git commit -m "$new_version" $release_notes_file
      echo "Tag $new_version"
      git tag $new_version
      echo "Push tag $new_version"
      git push origin $new_version
      echo "Push commit to $production_branch"
      git push origin $production_branch
    fi
  fi
fi
