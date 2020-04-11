#!/bin/bash

[ -n "$DEBUG" ] && set -x

if [ -z "$DOCKER_HUB_LOGIN" ] || [ -z "$DOCKER_HUB_PASSWORD" ]; then
  echo "DOCKER_HUB_LOGIN or DOCKER_HUB_PASSWORD is empty"
  echo "Please setup secret variables in gitlab CI"
  exit 1
fi

##changed_files=$(git diff --raw --name-only HEAD^1)
echo "Find changed files..."
git diff --raw --name-only HEAD^1 | while IFS= read -r line; do
  echo "$line"
  if [[ $line =~ ([^/]*)/image.*/ ]]; then
    build_dir="${BASH_REMATCH[1]}/image"
    if [ -f "$build_dir/.docker_image" ]; then
      image=$(head -1 "$build_dir/.docker_image")
      image=${image//[$'\t\r\n ']}
    else
      image="${BASH_REMATCH[1]}"
    fi
    if [ -f "$build_dir/.docker_tag" ]; then
      tag=$(head -1 "$build_dir/.docker_tag")
      tag=${tag//[$'\t\r\n ']}
    else
      tag=$(date '+%Y%m%d%H%m')
    fi
    if [ -f "$build_dir/.clone_git" ]; then
      git_url=$(cat "$build_dir/.clone_git")
      git clone "$git_url" "${build_dir}/git_repo"
    fi
    echo "|$image|"
    echo "|$tag|"
    docker_build_dir="."
    [ -n "$git_url" ] && docker_build_dir="${build_dir}/git_repo"
    if [ -f "$build_dir/Dockerfile" ]; then
      docker login -u "$DOCKER_HUB_LOGIN" -p "$DOCKER_HUB_PASSWORD"
      if docker build -t "$DOCKER_HUB_LOGIN/$image:$tag" -t "$DOCKER_HUB_LOGIN/$image:latest" -f "$build_dir/Dockerfile" "$docker_build_dir" ; then
        docker push "$DOCKER_HUB_LOGIN/$image:$tag"
        docker push "$DOCKER_HUB_LOGIN/$image:latest"
      else
        echo "Docker build failed"
        exit 1
      fi
    fi
  fi
done
