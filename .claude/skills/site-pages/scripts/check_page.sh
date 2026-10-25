#!/usr/bin/env bash
# Sanity-check site pages: template markers, stylesheet path, local links, image attributes.
# Usage: bash check_page.sh page.html [page2.html ...]   (run from anywhere inside the repo)

status=0
root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

for page in "$@"; do
  problems=()
  if [ ! -f "$page" ]; then echo "MISSING FILE: $page"; status=1; continue; fi
  dir=$(dirname "$page")

  # Template markers: exactly one of each, in the right order
  for m in 'InstanceBegin template=' '#BeginEditable "doctitle"' '#EndEditable' \
           'InstanceBeginEditable name="Main"' 'InstanceEndEditable' 'InstanceEnd -->'; do
    n=$(grep -c -- "$m" "$page")
    [ "$n" -eq 1 ] || problems+=("marker '$m' found $n times (expected 1)")
  done
  b=$(grep -n 'InstanceBeginEditable name="Main"' "$page" | head -1 | cut -d: -f1)
  e=$(grep -n 'InstanceEndEditable' "$page" | head -1 | cut -d: -f1)
  [ -n "$b" ] && [ -n "$e" ] && [ "$b" -ge "$e" ] && problems+=("Main region ends before it begins")
  grep -q 'TemplateBeginEditable\|TemplateEndEditable' "$page" && problems+=("leftover Template* markers (should be Instance*)")
  grep -q '<div class="main">' "$page" || problems+=('no <div class="main">')

  # Stylesheet must resolve to the root CSS/main.css
  css=$(grep -o 'href="[^"]*CSS/main.css"' "$page" | head -1 | sed 's/href="//;s/"$//')
  if [ -z "$css" ]; then problems+=("no link to CSS/main.css")
  elif [ ! -f "$dir/$css" ] || [ "$(cd "$dir/$(dirname "$css")" && pwd)" != "$(cd "$root/CSS" && pwd)" ]; then
    problems+=("main.css path '$css' does not reach the site root CSS folder")
  fi

  # Page with HTML comments removed: commented-out markup isn't shown, so don't check it
  live=$(perl -0pe 's/<!--.*?-->//gs' "$page")

  # Local href/src targets must exist (skip external, anchors, mailto, javascript)
  while IFS= read -r url; do
    case "$url" in http:*|https:*|//*|mailto:*|javascript:*|\#*|"") continue ;; esac
    # The Spry init script uses root-relative gif paths on every page; ignore them
    case "$url" in SpryAssets/SpryMenuBar*Hover.gif) continue ;; esac
    target="${url%%#*}"; target="${target%%\?*}"
    target=$(printf '%b' "${target//%/\\x}")   # decode %20 etc.
    [ -z "$target" ] && continue
    [ -e "$dir/$target" ] || problems+=("broken local link: $url")
  done < <(printf '%s' "$live" | grep -oE '(href|src)="[^"]*"' | sed -E 's/^(href|src)="//; s/"$//')

  # Images: width, height and alt present
  while IFS= read -r img; do
    for a in width height alt; do
      echo "$img" | grep -q " $a=" || problems+=("<img> missing $a: $img")
    done
  done < <(printf '%s' "$live" | grep -oE '<img [^>]*>')

  if [ ${#problems[@]} -eq 0 ]; then
    echo "OK: $page"
  else
    status=1
    echo "PROBLEMS in $page:"
    printf '  - %s\n' "${problems[@]}"
  fi
done
exit $status
