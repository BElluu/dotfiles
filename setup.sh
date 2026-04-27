#!/bin/bash
set -e

REPO_URL="https://github.com/BElluu/dotfiles.git"

echo "=== Neovim 12 & AI Setup ==="
echo "1) Full Install"
echo "2) Update Tools"
echo "3) Sync Config Only"
echo "4) Exit"
read -p "Selection: " CHOICE

setup_env() {
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

install_deps() {
    sudo apt update && sudo apt install -y alacritty tmux fzf ripgrep fd-find git unzip build-essential fontconfig libfuse2 nodejs npm
    
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    setup_env
    brew update && brew install neovim lazygit gcc
    
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version latest
    grep -qq "DOTNET_ROOT" ~/.bashrc || {
        echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
        echo 'export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools' >> ~/.bashrc
    }
}

install_ai() {
    sudo npm install -g @anthropic-ai/claude-code
    curl -fsSL https://cursor.com/install.sh | bash
}

install_fonts() {
    mkdir -p ~/.local/share/fonts
    curl -fLo "font.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o font.zip -d ~/.local/share/fonts
    rm -f font.zip
    fc-cache -fv
}

sync_config() {
    [ -d ~/.config/nvim ] && rm -rf ~/.config/nvim.bak && mv ~/.config/nvim ~/.config/nvim.bak
    rm -rf ~/.local/share/nvim/lazy
    
    TMP_DIR=$(mktemp -d)
    git clone "$REPO_URL" "$TMP_DIR"
    
    if [ -d "$TMP_DIR/nvim" ]; then
        mkdir -p ~/.config
        cp -r "$TMP_DIR/nvim" ~/.config/
    else
        echo "Error: 'nvim' directory not found in repo."
        exit 1
    fi
    rm -rf "$TMP_DIR"
}

case $CHOICE in
    1)
        install_deps
        install_ai
        install_fonts
        sync_config
        ;;
    2)
        setup_env
        brew upgrade
        sudo npm update -g @anthropic-ai/claude-code
        curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version latest
        ;;
    3)
        sync_config
        ;;
    *)
        exit 0
        ;;
esac

echo "Done. Restart terminal or source ~/.bashrc"
