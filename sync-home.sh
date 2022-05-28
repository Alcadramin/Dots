#!/usr/bin/env bash

TEMP=/tmp/included

if [[ -e $TEMP  ]]; then
    rm "$TEMP"
fi

git ls-tree -r main --name-only > "$TEMP"

while read -r DEST; do
    TARGET="$HOME/$DEST"

    if [[ -e $TARGET ]]; then
        DIFF=$(diff "$TARGET" "$DEST")
        if [[ -z "$DIFF" ]]; then
            continue;
        else
            echo "=> Copying $DEST"
            rsync -aqzrEP --no-perms --no-owner --no-group "$TARGET" "$DEST"
            #cp -r --parents --no-preserve=mode,ownership "$TARGET" .
        fi
    fi
done < "$TEMP"

#cp -R home/alcadramin/* .
#rm -r home/
