#!/bin/bash

[ -n "$DEBUG" ] && set -x

REPODIR=/srv/www/charts.nagg.ru/htdocs

t_charts=$(mktemp)

echo "Find changed files..."
git diff --raw --name-only HEAD^1 | while IFS= read -r line; do
  echo "$line"
  if [[ $line =~ ([^/]*)/ ]]; then
    echo "${BASH_REMATCH[1]}" >> "$t_charts"
  fi
done

sort -u "$t_charts" > "$t_charts".sort
echo "debug"
cat "$t_charts".sort

cat "$t_charts".sort | while IFS= read -r line; do
  if [ -f "./$line/$line/Chart.yaml" ]; then
    echo "Package chart $line"
## do not remove old charts keep it!
##    rm -f "$REPODIR/$line"*
    helm package --save=false -d "$REPODIR" "./$line/$line"
  fi
done

rm -f "$t_charts"
rm -f "$t_charts".sort

# create index
echo "Create index"
helm repo index "$REPODIR"
