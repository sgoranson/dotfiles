#!/usr/bin/env zsh
#

# SPACESHIP_TIME_SHOW=true
# SPACESHIP_VI_MODE_SHOW=true
# SPACESHIP_VI_MODE_PREFIX='VI'
# SPACESHIP_VI_MODE_INSERT='I'
# SPACESHIP_VI_MODE_NORMAL='N'
# # SPACESHIP_BATTERY_SHOW=always

# SPACESHIP_RPROMPT_ORDER=( 
# time 
# vi_mode
# )

export SPACESHIP_PROMPT_ORDER=(
  user
  dir
  host
  git_branch
  git_status
  kubecontext
  azure
  exec_time
  line_sep
  jobs
  char
)
export SPACESHIP_RPROMPT_ORDER=(
time 
)

export SPACESHIP_CHAR_SYMBOL="❯ "
export SPACESHIP_JOBS_SYMBOL="»"
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_USER_PREFIX="as "
export SPACESHIP_USER_SHOW="needed"
export SPACESHIP_DIR_TRUNC_PREFIX=".../"
export SPACESHIP_DIR_TRUNC_REPO=false
export SPACESHIP_KUBECONTEXT_COLOR_GROUPS=(
  red -prod-
)
# ORDER
# SPACESHIP_PROMPT_ORDER=(
#   time     #
#   vi_mode  # these sections will be
#   user     # before prompt char
#   host     #
#   char
#   dir
#   git
#   node
#   ruby
#   xcode
#   swift
#   golang
#   docker
#   venv
#   pyenv
# )

# # USER
# SPACESHIP_USER_PREFIX="" # remove `with` before username
# SPACESHIP_USER_SUFFIX="" # remove space before host

# # HOST
# # Result will look like this:
# #   username@:(hostname)
# SPACESHIP_HOST_PREFIX="@:("
# SPACESHIP_HOST_SUFFIX=") "

# # DIR
# SPACESHIP_DIR_PREFIX='' # disable directory prefix, cause it's not the first section
# SPACESHIP_DIR_TRUNC='1' # show only last directory

# # GIT
# # Disable git symbol
# SPACESHIP_GIT_SYMBOL="" # disable git prefix
# SPACESHIP_GIT_BRANCH_PREFIX="" # disable branch prefix too
# # Wrap git in `git:(...)`
# SPACESHIP_GIT_PREFIX='git:('
# SPACESHIP_GIT_SUFFIX=") "
# SPACESHIP_GIT_BRANCH_SUFFIX="" # remove space after branch name
# # Unwrap git status from `[...]`
# SPACESHIP_GIT_STATUS_PREFIX=""
# SPACESHIP_GIT_STATUS_SUFFIX=""

# # NODE
# SPACESHIP_NODE_PREFIX="node:("
# SPACESHIP_NODE_SUFFIX=") "
# SPACESHIP_NODE_SYMBOL=""

# # RUBY
# SPACESHIP_RUBY_PREFIX="ruby:("
# SPACESHIP_RUBY_SUFFIX=") "
# SPACESHIP_RUBY_SYMBOL=""

# # XCODE
# SPACESHIP_XCODE_PREFIX="xcode:("
# SPACESHIP_XCODE_SUFFIX=") "
# SPACESHIP_XCODE_SYMBOL=""

# # SWIFT
# SPACESHIP_SWIFT_PREFIX="swift:("
# SPACESHIP_SWIFT_SUFFIX=") "
# SPACESHIP_SWIFT_SYMBOL=""

# # GOLANG
# SPACESHIP_GOLANG_PREFIX="go:("
# SPACESHIP_GOLANG_SUFFIX=") "
# SPACESHIP_GOLANG_SYMBOL=""

# # DOCKER
# SPACESHIP_DOCKER_PREFIX="docker:("
# SPACESHIP_DOCKER_SUFFIX=") "
# SPACESHIP_DOCKER_SYMBOL=""

# # VENV
# SPACESHIP_VENV_PREFIX="venv:("
# SPACESHIP_VENV_SUFFIX=") "

# # PYENV
# SPACESHIP_PYENV_PREFIX="python:("
# SPACESHIP_PYENV_SUFFIX=") "
# SPACESHIP_PYENV_SYMBOL=""


autoload -U promptinit && promptinit
prompt spg
