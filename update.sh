#!/usr/bin/env bash
# Script to update bitpingd version and hashes in flake.nix
# Usage: ./update.sh

set -euo pipefail

FLAKE_FILE="flake.nix"

echo "Fetching latest version from releases.bitping.com..."
update_json=$(curl -sL "https://releases.bitping.com/bitpingd/update.json")

if [[ -z "$update_json" ]]; then
    echo "Error: Failed to fetch update.json"
    exit 1
fi

version=$(echo "$update_json" | grep '"version":' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
echo "Latest version: $version"

# Platform mappings: Nix system -> bitping platform key
declare -A platform_map=(
    ["x86_64-linux"]="linux-x86_64"
    ["aarch64-linux"]="linux-aarch64"
    ["armv7l-linux"]="linux-armv7"
    ["x86_64-darwin"]="darwin-x86_64"
    ["aarch64-darwin"]="darwin-aarch64"
)

# Update version in flake.nix
echo "Updating version in $FLAKE_FILE..."
sed -i "s/version = \"[^\"]*\";/version = \"$version\";/" "$FLAKE_FILE"

# Fetch and update hashes for each platform
for nix_system in "${!platform_map[@]}"; do
    platform_key="${platform_map[$nix_system]}"

    echo "Processing $nix_system ($platform_key)..."

    # Extract URL from update.json
    url=$(echo "$update_json" | grep -A 3 "\"$platform_key\":" | grep '"url":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [[ -z "$url" ]]; then
        echo "  Warning: No URL found for $platform_key, skipping..."
        continue
    fi

    echo "  URL: $url"

    # Prefetch and get hash
    echo "  Prefetching..."
    hash=$(nix-prefetch-url "$url" 2>/dev/null)
    sri_hash=$(nix hash to-sri --type sha256 "$hash")

    echo "  Hash: $sri_hash"

    # Update the URL in flake.nix
    # This is a simple replacement - may need adjustment based on actual URL structure
    sed -i "/$nix_system = {/,/};/ s|url = \"[^\"]*\";|url = \"$url\";|" "$FLAKE_FILE"
    sed -i "/$nix_system = {/,/};/ s|hash = \"[^\"]*\";|hash = \"$sri_hash\";|" "$FLAKE_FILE"
done

echo ""
echo "Update complete! Please review changes in $FLAKE_FILE"
echo "Then run: nix flake check"
