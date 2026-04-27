#!/bin/bash
set -e

REPO_URL="https://github.com/BElluu/dotfiles.git"

echo "=== Dotfiles v1.0 ==="
echo "1) Full Install"
echo "2) Update Tools (Brew, NPM, .NET)"
echo "3) Overwrite nvim"
echo "4) Exit"
read -p "Selection: " CHOICE

setup_env() {
    export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

install_deps() {
    echo "Installing system dependencies..."
    sudo apt update && sudo apt install -y alacritty tmux fzf ripgrep fd-find git unzip build-essential fontconfig libfuse2 nodejs npm curl

    echo "Installing tree-sitter-cli via npm..."
    sudo npm install -g tree-sitter-cli

    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    setup_env
    brew update && brew install neovim lazygit gcc
    
    echo "Installing .NET SDK..."
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version latest
    
    if ! grep -q "DOTNET_ROOT" ~/.bashrc; then
        echo 'export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"' >> ~/.bashrc
        echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
        echo 'export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools' >> ~/.bashrc
    fi
}

install_ai() {
    echo "Installing AI tools..."
    sudo npm install -g @anthropic-ai/claude-code
    curl https://cursor.com/install.sh -fsS | bash
    if ! grep -q ".local/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
}

install_fonts() {
    echo "Installing JetBrainsMono Nerd Font..."
    mkdir -p ~/.local/share/fonts
    curl -fLo "font.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o font.zip -d ~/.local/share/fonts
    rm -f font.zip
    fc-cache -fv
}

sync_config() {
    echo "Syncing config from: $REPO_URL"
    rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
    
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
        echo "Updating tools..."
        brew upgrade
        sudo npm update -g tree-sitter-cli @anthropic-ai/claude-code
        curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version latest
        ;;
    3)
        sync_config
        ;;
    *)
        exit 0
        ;;
esac

echo "Done. Please restart your terminal or run: source ~/.bashrc"
