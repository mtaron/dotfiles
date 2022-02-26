#!/bin/bash

gh release download --repo microsoft/cascadia-code --pattern 'CascadiaCode*.zip'
file_name=$(ls CascadiaCode*.zip)

# Just install ttf variable fonts per https://github.com/microsoft/cascadia-code#installation
# Quite, overwrite, and don't create folders options
unzip -oqj "$file_name" 'ttf/*.ttf' -x 'ttf/static/*' -d "$HOME/.fonts"

rm "$file_name"

# Build font cache
fc-cache