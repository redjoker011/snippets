#!/bin/bash

# Usage release_cleanup.sh path_to_directory

RELEASES_DIR="$1"

MAX_RELEASES_LENGTH=5
DIRS=()

echo $RELEASES_DIR

result=$(cd $RELEASES_DIR; ls -d */)

echo $result

for i in $result; do DIRS+=("${i%%/}"); done

DIRS=($(echo ${DIRS[*]}| tr " " "\n" | sort -n))
LENGTH=${#DIRS[@]}
INDEX=`expr ${#DIRS[@]} - $MAX_RELEASES_LENGTH`
INDEX=$(( $INDEX < 0 ? 0 : $INDEX ))

echo $DIRS
REMOVABLE_DIRS=()
echo $REMOVABLE_DIRS
for i in "${DIRS[@]}"; do
    skip=
    for j in "${DIRS[@]:INDEX}"; do
        [[ $i == $j ]] && { skip=1; break; }
    done
    [[ -n $skip ]] || REMOVABLE_DIRS+=("$i")
done

$(cd $RELEASES_DIR; rm -rf ${REMOVABLE_DIRS[@]})
