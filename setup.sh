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
  sudo apt update && sudo apt install -y alacritty tmux fzf ripgrep fd-find git unzip build-essential fontconfig libfuse2 curl

  install_node_via_nvm

  echo "Installing tree-sitter-cli via npm..."
  npm install -g tree-sitter-cli

  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  setup_env
  brew update && brew install neovim lazygit gcc
  brew install zsh antidote zoxide atuin sesh

  echo "Installing .NET SDK..."
  curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version latest

  # UWAGA: nic nie dopisujemy do ~/.bashrc — bashrc/zshrc sa wersjonowane
  # w tym repo i podpinane symlinkiem w sync_config(). Wczesniej dwa osobne
  # bloki dopisywaly ten sam export PATH, stad duplikaty w PATH.
}

install_ai() {
  echo "Installing AI tools..."
  npm install -g @anthropic-ai/claude-code
  curl https://cursor.com/install.sh -fsS | bash
}

install_fonts() {
  echo "Installing JetBrainsMono Nerd Font..."
  mkdir -p ~/.local/share/fonts
  curl -fLo "font.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -o font.zip -d ~/.local/share/fonts
  rm -f font.zip
  fc-cache -fv
}

install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

install_node_via_nvm() {

  if command -v node &>/dev/null && command -v npm &>/dev/null; then

    echo "Node.js is already installed ($(node -v)). Skipping..."

  else

    echo "Node.js not found. Installing NVM and Node 24..."

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    

    export NVM_DIR="$HOME/.nvm"

    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    

    nvm install 24

    nvm use 24

    nvm alias default 24

    # nvm jest juz obslugiwane (leniwie) w wersjonowanym bashrc/zshrc

  fi

}
sync_config() {
  DOTFILES_DIR="$HOME/code/dotfiles"

  if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "Updating existing repo at $DOTFILES_DIR..."
    git -C "$DOTFILES_DIR" pull
  else
    echo "Cloning repo to $DOTFILES_DIR..."
    mkdir -p "$HOME/code"
    git clone "$REPO_URL" "$DOTFILES_DIR"
  fi

  # Clear nvim state/cache but NOT the config dir (it will be a symlink)
  rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

  rm -rf ~/.config/nvim
  mkdir -p ~/.config
  ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
  echo "nvim config symlinked: ~/.config/nvim -> $DOTFILES_DIR/nvim"

  ln -sf "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
  echo "tmux config symlinked: ~/.tmux.conf -> $DOTFILES_DIR/tmux.conf"

  mkdir -p ~/.config/tmux
  ln -sf "$DOTFILES_DIR/tmux/sessions.sh" ~/.config/tmux/sessions.sh
  chmod +x "$DOTFILES_DIR/tmux/sessions.sh"
  echo "sessions script symlinked: ~/.config/tmux/sessions.sh -> $DOTFILES_DIR/tmux/sessions.sh"

  ln -sf "$DOTFILES_DIR/tmux/help.sh" ~/.config/tmux/help.sh
  chmod +x "$DOTFILES_DIR/tmux/help.sh"
  echo "help script symlinked: ~/.config/tmux/help.sh -> $DOTFILES_DIR/tmux/help.sh"

  [ -e ~/.bashrc ] && [ ! -L ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.pre-dotfiles
  [ -e ~/.zshrc ]  && [ ! -L ~/.zshrc ]  && mv ~/.zshrc  ~/.zshrc.pre-dotfiles
  ln -sfn "$DOTFILES_DIR/bash/bashrc"          ~/.bashrc
  ln -sfn "$DOTFILES_DIR/zsh/zshrc"            ~/.zshrc
  ln -sfn "$DOTFILES_DIR/zsh/zsh_plugins.txt"  ~/.zsh_plugins.txt
  echo "shell configs symlinked: ~/.bashrc, ~/.zshrc, ~/.zsh_plugins.txt"

  mkdir -p ~/.local/bin
  for f in "$DOTFILES_DIR"/bin/*; do
    [ -f "$f" ] || continue
    chmod +x "$f"
    ln -sfn "$f" ~/.local/bin/"$(basename "$f")"
  done
  echo "scripts symlinked: $DOTFILES_DIR/bin/* -> ~/.local/bin/"
}

case $CHOICE in
1)
  install_deps
  install_ai
  install_fonts
  install_tpm
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
