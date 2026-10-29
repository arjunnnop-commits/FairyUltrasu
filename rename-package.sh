#!/bin/bash
# Renames com.rifsxd.ksunext -> com.fairyultra.manager and APK name -> FairyUltra_*
# Safe to run multiple times.
set -e
cd "$(dirname "$0")"

OLD_DOT="com.rifsxd.ksunext"; NEW_DOT="com.fairyultra.manager"
OLD_SLASH="com/rifsxd/ksunext"; NEW_SLASH="com/fairyultra/manager"
OLD_US="com_rifsxd_ksunext"; NEW_US="com_fairyultra_manager"

# 1. Move source folders
for d in $(find manager -type d -path "*/$OLD_SLASH" 2>/dev/null); do
  base="${d%/$OLD_SLASH}"
  mkdir -p "$base/com/fairyultra"
  mv "$d" "$base/$NEW_SLASH"
  rmdir "$base/com/rifsxd" 2>/dev/null || true
done

# 2. Replace text inside manager app and ksud
grep -rIl -e "rifsxd.ksunext" -e "rifsxd/ksunext" -e "rifsxd_ksunext" manager userspace 2>/dev/null | while read -r f; do
  sed -i -e "s/com\.rifsxd\.ksunext/$NEW_DOT/g" \
         -e "s#$OLD_SLASH#$NEW_SLASH#g" \
         -e "s/$OLD_US/$NEW_US/g" "$f"
done

# 3. APK file name
sed -i 's/KernelSU_Next_/FairyUltra_/' manager/app/build.gradle.kts

echo "Rename done."
