#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

api_adr=${API_URL:-https://api.opensensemap.org}
maptiles_adr=${MAPTILES_URL:-http://\{s\}.tile.openstreetmap.org/\{z\}/\{x\}/\{y\}.png}

sed -i -e "s|OPENSENSEMAP_API_URL|$api_adr|g" -e "s|OPENSENSEMAP_MAPTILES_URL|$maptiles_adr|g" /usr/src/app/dist/scripts/*.scripts.js

# gzip scripts.js after replacing URL placeholder
gzip -k -f /usr/src/app/dist/scripts/*.scripts.js

find /usr/src/app/dist/ -type f \( -iname \*.js -o -iname \*.css -o -iname \*.html \) | while read file; do
  bro --input $file --output $file.br --quality 9
  echo "Compressed file '$file'"
done

exec /bin/true
