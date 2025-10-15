#!/bin/bash
STARSHIP_CONFIG=https://raw.githubusercontent.com/cybernop/setup-shell/refs/heads/main/starship.toml

###
# Install fish and starship
###
echo Install fish and starship

# MacOS
which brew > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    brew install fish starship

else
    # Alpine
    which apk > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        sudo apk add fish starship

    else
        echo Not configured for this environment
        exit 1

    fi

fi

###
# Setup shell
###
# Add to list of shells
fish_path=$(which fish)
if [[ -z "$(grep "^${fish_path}\$" /etc/shells)" ]]; then
    echo Add fish to list of shells
    sudo echo "${fish_path}" >> /etc/shells

else
    echo fish is already in the list of shells

fi

# Set default shell
if [[ "$SHELL" != "$fish_path" ]]; then
    echo Set fish as default shell
    chsh -s "${fish_path}"

else
    echo fish is already the default shell

fi

###
# Setup starship
###

# Copy starship config
echo Copy starship config
curl -sSL "$STARSHIP_CONFIG" -o "$HOME/.config/starship.toml"

if [[ "$?" -ne 0 ]]; then
    echo failed to download starship config
    exit 1

fi

# Enable Starship in fish config
fish_config="$HOME/.config/fish/config.fish"
if [[ ! -f "$fish_config" ]] || [[ -z "$(grep "^starship init fish | source\$" "$fish_config")" ]]; then
    echo Set starfish to be loaded
    mkdir -p "$HOME/.config/fish"
    echo "" >> "$fish_config"
    echo "# Enable Starship prompt" >> "$fish_config"
    echo "starship init fish | source" >> "$fish_config"

else
    echo Starfish already set to be loaded

fi

echo setup done
