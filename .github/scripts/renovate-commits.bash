#!/usr/bin/env bash

set -Eeuo pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <owner/repo> <old_sha> <new_sha>"
  exit 1
fi

OWNER_REPO=$1
OLD_SHA=$2
NEW_SHA=$3

function get_indicator() {
  local msg="$1"
  # Check for breaking change first
  if [[ "$msg" =~ ^[a-zA-Z]+(\([^\)]+\))?!: ]]; then
    echo "💥"
  elif [[ "$msg" =~ ^feat(\([^\)]+\))?: ]]; then
    echo "✨"
  elif [[ "$msg" =~ ^fix(\([^\)]+\))?: ]]; then
    echo "🐛"
  elif [[ "$msg" =~ ^perf(\([^\)]+\))?: ]]; then
    echo "🚀"
  elif [[ "$msg" =~ ^refactor(\([^\)]+\))?: ]]; then
    echo "🛠️"
  elif [[ "$msg" =~ ^docs(\([^\)]+\))?: ]]; then
    echo "📚"
  elif [[ "$msg" =~ ^test(\([^\)]+\))?: ]]; then
    echo "🧪"
  elif [[ "$msg" =~ ^chore(\([^\)]+\))?: ]]; then
    echo "🧹"
  elif [[ "$msg" =~ ^ci(\([^\)]+\))?: ]]; then
    echo "⚙️"
  elif [[ "$msg" =~ ^revert(\([^\)]+\))?: ]]; then
    echo "⏪"
  else echo "📝"; fi
}

# Normalize range to ... for GitHub API
RANGE="$OLD_SHA...$NEW_SHA"
REPO_NAME=$(echo "$OWNER_REPO" | cut -d'/' -f2)

# Start building the comment body
BODY="<!-- renovate-commits-view -->\n"
BODY+="### 📦 Upstream Updates\n\n"
BODY+="**$REPO_NAME** (\`${OLD_SHA:0:7}...${NEW_SHA:0:7}\`)\n\n"

# Fetch commits
commits_json=$(gh api "repos/$OWNER_REPO/compare/$RANGE" --jq '.commits[] | {sha: .sha, msg: .commit.message, url: .html_url}' 2>/dev/null || echo "[]")

if [ "$commits_json" == "[]" ] || [ -z "$commits_json" ]; then
  BODY+="- _No commits found or unable to fetch commits._\n"
else
  while read -r commit; do
    [ -z "$commit" ] && continue
    sha=$(echo "$commit" | jq -r '.sha' | cut -c 1-7)
    msg=$(echo "$commit" | jq -r '.msg' | head -n 1)
    url=$(echo "$commit" | jq -r '.url')

    indicator=$(get_indicator "$msg")
    [ ${#msg} -gt 100 ] && msg="${msg:0:97}..."

    # Link PR references (#123) to the upstream repo
    msg=$(echo "$msg" | sed -E "s|#([0-9]+)|[#\1](https://github.com/$OWNER_REPO/pull/\1)|g")

    BODY+="- $indicator $msg ([$sha]($url))\n"

  done <<<"$(echo "$commits_json" | jq -c '.')"
fi

# Output for the workflow or stdout
if [ -n "${GITHUB_ACTIONS:-}" ]; then
  echo -e "$BODY" >pr_comment.md
else
  echo -e "$BODY"
fi
