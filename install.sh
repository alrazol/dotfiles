#!/bin/zsh

# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking your new $link"
    ln -s $file $link
  fi
}

# For some files `$name` in the present folder (except `*.sh`, `README.md` and `config`),
# backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
for name in aliases gitconfig zprofile zshrc direnvrc p10k.zsh; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    backup $target
    symlink $PWD/$name $target
  fi
done

# Install some ZSH plugins
CURRENT_DIR=`pwd`
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh plugin 'zsh-syntax-highlighting'..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "-----> Installing zsh plugin 'zsh-autosuggestions'..."
  git clone https://github.com/zsh-users/zsh-autosuggestions
fi
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-completions" ]; then
  echo "-----> Installing zsh plugin 'zsh-completions'..."
  git clone https://github.com/zsh-users/zsh-completions
fi

# Install some ZSH theme
ZSH_THEMES_DIR="$HOME/.oh-my-zsh/custom/themes"
mkdir -p "$ZSH_THEMES_DIR" && cd "$ZSH_THEMES_DIR"
if [ ! -d "$ZSH_THEMES_DIR/powerlevel10k" ]; then
  echo "-----> Installing zsh theme powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
fi

cd "$CURRENT_DIR"

# Sublime Text - Mac OS only
if [[ `uname` =~ "Darwin" ]]; then
  SUBLIME_PATH=~/Library/Application\ Support/Sublime\ Text
  mkdir -p "$SUBLIME_PATH/Packages/User" "$SUBLIME_PATH/Installed Packages"
  backup "$SUBLIME_PATH/Pacakges/User/Preferences.sublime-settings"
  backup "$SUBLIME_PATH/Pacakges/User/Package Control.sublime-settings"
  ln -s $PWD/Preferences.sublime-settings $SUBLIME_PATH/Pacakges/User/Preferences.sublime-settings
  ln -s $PWD/Preferences.Package Control.sublime-settings $SUBLIME_PATH/Pacakges/User/Preferences.sublime-settings
fi

# VScode
# USE VSCODE "SETTING SYNC" FEATURE INSTEAD OF DOTFILES TO SYNC `settings.json` and `keybindings.json`
# # Symlink VS Code settings and keybindings to the present `settings.json` and `keybindings.json` files
# # If it's a macOS
# if [[ `uname` =~ "Darwin" ]]; then
#   CODE_PATH=~/Library/Application\ Support/Code/User
# # Else, it's a Linux
# else
#   CODE_PATH=~/.config/Code/User
#   # If this folder doesn't exist, it's a WSL/Virtual Machine
#   if [ ! -e $CODE_PATH ]; then
#     CODE_PATH=~/.vscode-server/data/Machine
#   fi
# fi

# for name in settings.json keybindings.json; do
#   target="$CODE_PATH/$name"
#   backup $target
#   symlink $PWD/$name $target
# done

# Symlink SSH config file to the present `config` file for macOS and add SSH passphrase to the keychain
if [[ `uname` =~ "Darwin" ]]; then
  target=~/.ssh/config
  backup $target
  symlink $PWD/config $target
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
fi

# Refresh the current terminal with the newly installed configuration
exec zsh

echo "👌 Carry on with git setup!"
