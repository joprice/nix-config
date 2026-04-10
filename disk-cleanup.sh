# disk-cleanup: find reclaimable temp/cache space on macOS
set -euo pipefail

bold="\033[1m"
dim="\033[2m"
reset="\033[0m"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

dir_bytes() {
  if [[ -d "$1" ]]; then
    du -sk "$1" 2>/dev/null | awk '{print $1 * 1024}'
  else
    echo 0
  fi
}

# --- Launch all queries in parallel ---

dir_bytes ~/Library/Developer/Xcode/DerivedData > "$tmp/xcode_dd" &
dir_bytes ~/Library/Developer/Xcode/Archives > "$tmp/xcode_archives" &
dir_bytes ~/.cache/uv > "$tmp/uv" &
dir_bytes ~/Library/Caches/pip > "$tmp/pip" &
dir_bytes ~/.npm > "$tmp/npm" &
dir_bytes ~/Library/Caches/pnpm > "$tmp/pnpm" &
dir_bytes ~/.cache/nodejs-compile-cache > "$tmp/nodejs_cc" &
dir_bytes ~/.cargo/registry/cache > "$tmp/cargo" &
dir_bytes ~/.cache/huggingface > "$tmp/hf" &
dir_bytes ~/.cache/whisper > "$tmp/whisper" &
dir_bytes ~/.cache/torch > "$tmp/torch" &
dir_bytes ~/Library/Caches/Homebrew > "$tmp/brew" &
dir_bytes ~/Library/Caches/CocoaPods > "$tmp/pods" &
dir_bytes ~/Library/Caches/Google > "$tmp/google" &
dir_bytes ~/.cache/nix > "$tmp/nix" &
dir_bytes ~/Library/Logs > "$tmp/logs" &
dir_bytes ~/.gradle/caches > "$tmp/gradle" &
dir_bytes ~/.pyenv/versions > "$tmp/pyenv" &
dir_bytes ~/.cargo/registry/src > "$tmp/cargo_src" &
dir_bytes "$TMPDIR" > "$tmp/tmpdir" &
dir_bytes ~/Library/Caches/org.swift.swiftpm > "$tmp/swiftpm" &
dir_bytes ~/Library/Caches/go-build > "$tmp/go_build" &
dir_bytes ~/go/pkg/mod > "$tmp/go_mod" &
dir_bytes ~/Library/Caches/ms-playwright > "$tmp/playwright" &
dir_bytes ~/Library/Caches/maestro-studio-updater > "$tmp/maestro" &
dir_bytes ~/Library/Caches/ledger-live-desktop-updater > "$tmp/ledger" &
dir_bytes ~/Library/Application\ Support/Code/CachedExtensionVSIXs > "$tmp/vscode_vsix" &

# Simulator runtimes (xcrun is fast, but run in bg anyway)
(
  if command -v xcrun &>/dev/null; then
    sim_info=$(xcrun simctl runtime list 2>/dev/null || true)
    newest_ios=""
    newest_ios_uuid=""
    newest_ios_label=""
    # Collect all runtimes, then output stale ones
    declare -a all_uuids=() all_versions=() all_labels=()
    while IFS= read -r line; do
      if [[ "$line" =~ ^(iOS)[[:space:]]+([0-9.]+).*-[[:space:]]+([A-F0-9-]+) ]]; then
        all_uuids+=("${BASH_REMATCH[3]}")
        all_versions+=("${BASH_REMATCH[2]}")
        all_labels+=("iOS ${BASH_REMATCH[2]}")
        ver="${BASH_REMATCH[2]}"
        if [[ -z "$newest_ios" ]] || [[ "$(printf '%s\n%s' "$newest_ios" "$ver" | sort -V | tail -1)" == "$ver" ]]; then
          newest_ios="$ver"
        fi
      fi
    done <<< "$sim_info"
    for i in "${!all_uuids[@]}"; do
      if [[ "${all_versions[$i]}" != "$newest_ios" ]]; then
        echo "${all_uuids[$i]}|${all_labels[$i]}"
      fi
    done
  fi
) > "$tmp/sim_runtimes" &

# Docker queries
(
  if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
    dangling=$(docker volume ls -qf dangling=true 2>/dev/null | wc -l | tr -d ' ')
    if (( dangling > 0 )); then
      vol_size=$(docker system df -v 2>/dev/null \
        | awk '/VOLUME NAME/{found=1;next} found && /^[a-f0-9]/{s+=$3} END{printf "%.0f", s*1024*1024}' || echo 0)
      (( vol_size == 0 )) && vol_size=$(docker system df 2>/dev/null \
        | awk '/Local Volumes/{gsub(/[^0-9.]/,"",$4); printf "%.0f", $4*1024*1024*1024}' || echo 0)
      echo "volumes|$dangling|$vol_size"
    fi
    builder_raw=$(docker system df 2>/dev/null \
      | awk '/Build Cache/{print $4}' || echo "0")
    builder_bytes=$(echo "$builder_raw" | awk '{
      s=$1; gsub(/[^0-9.]/,"",s); u=$1; gsub(/[0-9.]/,"",u);
      if(u=="GB") printf "%.0f", s*1024*1024*1024;
      else if(u=="MB") printf "%.0f", s*1024*1024;
      else if(u=="kB") printf "%.0f", s*1024;
      else print 0
    }')
    echo "builder|0|$builder_bytes"
  fi
) > "$tmp/docker" &

# --- Wait for all background jobs ---
wait

# --- Format and print results ---

total_bytes=0

row() {
  local size_bytes=$1 desc=$2 cmd=$3
  if (( size_bytes == 0 )); then return; fi
  total_bytes=$((total_bytes + size_bytes))
  local human
  human=$(numfmt --to=iec --suffix=B --format="%.1f" "$size_bytes" 2>/dev/null \
    || awk "BEGIN{s=$size_bytes; u=\"B\"; split(\"K M G T\",a);
      for(i=1;i<=4&&s>=1024;i++){s/=1024;u=a[i]\"B\"} printf \"%.1f%s\",s,u}")
  printf "  ${bold}%8s${reset}  %-44s ${dim}%s${reset}\n" "$human" "$desc" "$cmd"
}

echo ""
printf "${bold}Reclaimable disk space${reset}\n"
echo ""

row "$(cat "$tmp/xcode_dd")" "Xcode DerivedData" "rm -rf ~/Library/Developer/Xcode/DerivedData"
row "$(cat "$tmp/xcode_archives")" "Xcode Archives" "rm -rf ~/Library/Developer/Xcode/Archives"

# Stale simulator runtimes (~8GB each)
while IFS='|' read -r uuid label; do
  [[ -z "$uuid" ]] && continue
  row 8589934592 "Simulator runtime: $label" "xcrun simctl runtime delete $uuid"
done < "$tmp/sim_runtimes"

row "$(cat "$tmp/uv")" "uv cache" "uv cache clean"
row "$(cat "$tmp/pip")" "pip cache" "pip cache purge"
row "$(cat "$tmp/npm")" "npm cache" "npm cache clean --force"
row "$(cat "$tmp/pnpm")" "pnpm cache" "pnpm store prune"
row "$(cat "$tmp/nodejs_cc")" "Node.js compile cache" "rm -rf ~/.cache/nodejs-compile-cache"
row "$(cat "$tmp/cargo")" "Cargo registry cache" "cargo cache --autoclean  # or rm -rf"
row "$(cat "$tmp/hf")" "Hugging Face models" "rm -rf ~/.cache/huggingface/hub"
row "$(cat "$tmp/whisper")" "Whisper models" "rm -rf ~/.cache/whisper"
row "$(cat "$tmp/torch")" "PyTorch hub cache" "rm -rf ~/.cache/torch"
row "$(cat "$tmp/brew")" "Homebrew cache" "brew cleanup --prune=all"
row "$(cat "$tmp/pods")" "CocoaPods cache" "pod cache clean --all"

# Docker results
while IFS='|' read -r kind count size; do
  [[ -z "$kind" ]] && continue
  if [[ "$kind" == "volumes" ]]; then
    row "$size" "Docker dangling volumes ($count)" "docker volume prune"
  elif [[ "$kind" == "builder" ]]; then
    row "$size" "Docker build cache (reclaimable)" "docker builder prune"
  fi
done < "$tmp/docker"

row "$(cat "$tmp/google")" "Google Chrome cache" "rm -rf ~/Library/Caches/Google"
row "$(cat "$tmp/gradle")" "Gradle caches" "rm -rf ~/.gradle/caches"
row "$(cat "$tmp/pyenv")" "pyenv Python versions" "pyenv versions  # then uninstall unused"
row "$(cat "$tmp/cargo_src")" "Cargo registry sources" "rm -rf ~/.cargo/registry/src"
row "$(cat "$tmp/tmpdir")" "User temp files (\$TMPDIR)" "rm -rf \$TMPDIR/*"
row "$(cat "$tmp/swiftpm")" "Swift Package Manager cache" "rm -rf ~/Library/Caches/org.swift.swiftpm"
row "$(cat "$tmp/go_build")" "Go build cache" "go clean -cache"
row "$(cat "$tmp/go_mod")" "Go module cache" "go clean -modcache"
row "$(cat "$tmp/playwright")" "Playwright browsers" "rm -rf ~/Library/Caches/ms-playwright"
row "$(cat "$tmp/maestro")" "Maestro updater cache" "rm -rf ~/Library/Caches/maestro-studio-updater"
row "$(cat "$tmp/ledger")" "Ledger Live updater cache" "rm -rf ~/Library/Caches/ledger-live-desktop-updater"
row "$(cat "$tmp/vscode_vsix")" "VS Code cached extensions" "rm -rf ~/Library/Application\ Support/Code/CachedExtensionVSIXs"
row "$(cat "$tmp/nix")" "Nix cache" "rm -rf ~/.cache/nix"
row "$(cat "$tmp/logs")" "macOS app logs" "sudo rm -rf ~/Library/Logs/*"

echo ""
total_human=$(numfmt --to=iec --suffix=B --format="%.1f" "$total_bytes" 2>/dev/null \
  || awk "BEGIN{s=$total_bytes; u=\"B\"; split(\"K M G T\",a);
    for(i=1;i<=4&&s>=1024;i++){s/=1024;u=a[i]\"B\"} printf \"%.1f%s\",s,u}")
printf "  ${bold}%8s  Total reclaimable${reset}\n" "$total_human"
echo ""
