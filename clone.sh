#!/usr/bin/env bash
#
# Example clone.sh for orchestrator repo.
#
# Behaviour:
# - For each sub-repo: if directory exists, run git pull; otherwise git clone.
# - Uses username and access token from arguments for authenticated clone/pull.
#
# Usage: ./clone.sh <username> <access_token>

set -e

if [ $# -lt 2 ]; then
  exit 1
fi

USERNAME="$1"
ACCESS_TOKEN="$2"

# ```CUSTOMIZE THIS SECTION: Add your sub-repository URLs here```
REPOS=(
  "https://github.com/ktamburi/quarkus-test-1.git"
)

urlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * ) printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  printf '%s' "${encoded}"
}

auth_url() {
  local url="$1"
  if [[ "$url" =~ ^https://([^@]+@)?([^/]+)(/.*)$ ]]; then
    local host_path="${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
    local encoded_username=$(urlencode "$USERNAME")
    local encoded_token=$(urlencode "$ACCESS_TOKEN")
    printf 'https://%s:%s@%s' "$encoded_username" "$encoded_token" "$host_path"
  else
    printf '%s' "$url"
  fi
}

for url in "${REPOS[@]}"; do
  if [[ "$url" =~ /([^/]+)\.git$ ]]; then
    name="${BASH_REMATCH[1]}"
  else
    name="repo-$(basename "$url" .git)"
  fi
  
  # Check if repository directory already exists (was cloned before)
  if [ -d "$name/.git" ]; then
    # Repository exists: pull latest changes
    (cd "$name" && git pull)
  else
    # Repository doesn't exist: clone it
    git clone "$(auth_url "$url")" "$name"
  fi
done
