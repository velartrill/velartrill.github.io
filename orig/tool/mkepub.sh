#!/usr/bin/env bash
book="$1"
target="$2"
if test "$target" = ""; then
	target="$(dirname "$book")/$(basename "$book").epub"
fi

declare -a chapts
while read -r line; do
	chapts+=("$line")
done <"$book/index"

declare -a etc
if test -f "$book/cover.png"; then
	etc+=(--epub-cover-image "$book/cover.png")
fi

(for i in "${chapts[@]}"; do
	lua tool/cleanmeta.lua "$book/$i.md"
	echo # ensure break
done) | pandoc -fmarkdown -tepub \
	"$book/title" - \
	-o "$target" \
	-d "$book/def.yml" "${etc[@]}"
