# Fig pre block. Keep at the top of this file.
# [[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"
echo "💫load zprofile"

# Add brew to path
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Setup the PATH for pyenv binaries and shims
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# type -a pyenv > /dev/null && eval "$(pyenv init --path)"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Fig post block. Keep at the bottom of this file.
# [[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"

