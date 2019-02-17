
if command -v rbenv &>/dev/null; then
    eval "$(rbenv init -)"
    source $HOME/.rbenv/completions/rbenv.zsh
fi
# Lazy load rbenv
# if type rbenv &> /dev/null; then
#   local RBENV_SHIMS="${RBENV_ROOT:-${HOME}/.rbenv}/shims"
#   export PATH="${RBENV_SHIMS}:${PATH}"
#   source $(whence -p rbenv)/../../completions/rbenv.zsh
#   function rbenv() {
#     unset -f rbenv > /dev/null 2>&1
#     eval "$(command rbenv init -)"
#     rbenv "$@"
#   }
# fi


# if command -v pyenv &>/dev/null; then
#     eval "$(pyenv init -)"
# fi

# Try to find pyenv, if it's not on the path
export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
if ! type pyenv > /dev/null && [ -f "${PYENV_ROOT}/bin/pyenv" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

# Lazy load pyenv
if type pyenv > /dev/null; then
    export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"
    function pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        pyenv $@
    }
fi



path=("$HOME/.pyenv/bin" "$HOME/.node/bin/" "$HOME/.rbenv/bin" $path )
