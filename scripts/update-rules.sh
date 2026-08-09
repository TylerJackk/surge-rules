#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rules_dir="${repo_dir}/Rules"
manual_dir="${rules_dir}/Manual"
update_time="$(TZ=Asia/Shanghai date '+%Y.%m.%d %H:%M:%S')"

mkdir -p "${rules_dir}" "${manual_dir}"

clean_manual_file() {
  local source_file="$1"
  if [[ -f "${source_file}" ]]; then
    sed 's/\r$//' "${source_file}" | awk 'NF && $0 !~ /^#/'
  fi
}

download_clean() {
  local source_url="$1"
  curl --fail --silent --show-error --location --retry 3 "${source_url}" \
    | sed 's/\r$//' \
    | awk 'NF && $0 !~ /^#/'
}

write_ruleset() {
  local name="$1"
  local source_url="$2"
  local manual_file="${manual_dir}/${name}.txt"
  local exclude_file="${manual_dir}/${name}.exclude.txt"
  local body_file
  local upstream_file
  local filtered_file
  body_file="$(mktemp)"
  upstream_file="$(mktemp)"
  filtered_file="$(mktemp)"

  clean_manual_file "${manual_file}" > "${body_file}"
  download_clean "${source_url}" > "${upstream_file}"

  if [[ -s "${exclude_file}" ]]; then
    clean_manual_file "${exclude_file}" > "${filtered_file}"
    if [[ -s "${filtered_file}" ]]; then
      grep -vFf "${filtered_file}" "${upstream_file}" >> "${body_file}" || true
    else
      cat "${upstream_file}" >> "${body_file}"
    fi
  else
    cat "${upstream_file}" >> "${body_file}"
  fi

  awk '!seen[$0]++' "${body_file}" > "${body_file}.dedup"
  local total
  total="$(wc -l < "${body_file}.dedup" | tr -d ' ')"

  {
    echo "# NAME: ${name}"
    echo "# AUTHOR: TylerJackk"
    echo "# REPO: https://github.com/TylerJackk/surge-rules"
    echo "# UPDATED: ${update_time}"
    echo "# TOTAL: ${total}"
    echo
    cat "${body_file}.dedup"
  } > "${rules_dir}/${name}.list"

  rm -f "${body_file}" "${body_file}.dedup" "${upstream_file}" "${filtered_file}"
}

write_manual_only() {
  local name="$1"
  local manual_file="${manual_dir}/${name}.txt"
  local body_file
  body_file="$(mktemp)"
  clean_manual_file "${manual_file}" | awk '!seen[$0]++' > "${body_file}"
  local total
  total="$(wc -l < "${body_file}" | tr -d ' ')"

  {
    echo "# NAME: ${name}"
    echo "# AUTHOR: TylerJackk"
    echo "# REPO: https://github.com/TylerJackk/surge-rules"
    echo "# UPDATED: ${update_time}"
    echo "# TOTAL: ${total}"
    if [[ "${total}" -gt 0 ]]; then
      echo
      cat "${body_file}"
    fi
  } > "${rules_dir}/${name}.list"
  rm -f "${body_file}"
}

write_ruleset "AIGC" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/OpenAI/OpenAI.list"
write_ruleset "Telegram" "https://ruleset.skk.moe/List/ip/telegram.conf"
write_ruleset "YouTube" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/YouTube/YouTube.list"
write_ruleset "Netflix" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Netflix/Netflix.list"
write_ruleset "Disney" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Disney/Disney.list"
write_ruleset "BiliBili" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/BiliBili/BiliBili.list"
write_ruleset "GlobalMedia" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GlobalMedia/GlobalMedia_All_No_Resolve.list"
write_ruleset "Apple" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Apple/Apple_All_No_Resolve.list"
write_ruleset "Microsoft" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Microsoft/Microsoft.list"
write_ruleset "Proxy" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Proxy/Proxy_All_No_Resolve.list"
write_ruleset "China" "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/China/China_All_No_Resolve.list"
write_ruleset "ChinaCIDR" "https://raw.githubusercontent.com/Loyalsoldier/surge-rules/release/ruleset/cncidr.txt"
write_manual_only "Direct"

echo "Updated Surge rules in ${rules_dir}"
