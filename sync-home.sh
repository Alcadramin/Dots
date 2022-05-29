#!/usr/bin/env bash

# So if you've noticed, the directory structure of my repo and home folder is exactly the same.
# I got sick of manually copying files to my repo and this stupid script is came to live.
# It's just syncs exactly to the files in this repo from my home folder, if it's exist. 
# Feel free to steal it :D

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
