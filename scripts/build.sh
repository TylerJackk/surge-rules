#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="${repo_dir}/source"
publish_dir="${repo_dir}/publish"

rm -rf "${publish_dir}"
mkdir -p "${publish_dir}/ruleset" "${publish_dir}/modules"

build_domains() {
  local name="$1"
  local input="${source_dir}/${name}.txt"
  local domain_output="${publish_dir}/${name}.txt"
  local ruleset_output="${publish_dir}/ruleset/${name}.txt"

  awk '
    {
      sub(/\r$/, "")
      sub(/^[[:space:]]+/, "")
      sub(/[[:space:]]+$/, "")
    }
    NF && $0 !~ /^#/ { print }
  ' "${input}" | LC_ALL=C sort -u > "${domain_output}"

  awk '
    /^\./ {
      value = substr($0, 2)
      if (value != "") print "DOMAIN-SUFFIX," value
      next
    }
    { print "DOMAIN," $0 }
  ' "${domain_output}" > "${ruleset_output}"
}

for list_name in direct proxy reject; do
  build_domains "${list_name}"
done

if compgen -G "${repo_dir}/modules/*.sgmodule" > /dev/null; then
  cp "${repo_dir}"/modules/*.sgmodule "${publish_dir}/modules/"
fi

echo "Generated Surge assets in ${publish_dir}"
