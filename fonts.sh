#!/bin/bash

fonts_dir="$XDG_DATA_HOME/fonts"

download-cascadia-code()
{
    temp_dir=$(mktemp -d)

    gh release download --repo microsoft/cascadia-code --pattern 'CascadiaCode*.zip' --dir "$temp_dir"
    cascadia_code=$(ls CascadiaCode*.zip)

    # Just install ttf variable fonts per https://github.com/microsoft/cascadia-code#installation
    # Quite, overwrite, and don't create folders options
    unzip -oqj "$cascadia_code" 'ttf/*.ttf' -x 'ttf/static/*' -d "$fonts_dir"

    rm -rf "$temp_dir"
}

download-imb-plex()
{
    temp_dir=$(mktemp -d)

    gh release download --repo IBM/plex --pattern 'TrueType.zip' --dir "$temp_dir"


    rm -rf "$temp_dir"
}



download-cascadia-code
download-imb-plex

# Build font cache
fc-cache -v
