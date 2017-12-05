# Senpai
# by Sergi Barroso
# https://github.com/hiroru/senpai-zsh
# MIT License

k8s_info() {
  if [ -f ~/.kube/config ]; then
    k8s_context=$(awk '/current-context/{print $2}' $HOME/.kube/config)
    if [ ! -z ${k8s_context} ]; then
      echo " %F{74}⎈ ${k8s_context}%f"
    fi
  fi
}

aws_info() {
  if [ ! -z ${AWS_PROFILE} ]; then
    echo " %F{214}ⓦ ${AWS_PROFILE}%f"
  fi
}

prompt_senpai_git() {
  [[ -n ${git_info} ]] && print -n " ${(e)git_info[prompt]}"
}

prompt_senpai_virtualenv() {
  [[ -n ${VIRTUAL_ENV} ]] && print -n " (%F{blue}${VIRTUAL_ENV:t}%f)"
}

prompt_senpai_precmd() {
  (( ${+functions[git-info]} )) && git-info
}

prompt_senpai_setup() {
  [[ -n ${VIRTUAL_ENV} ]] && export VIRTUAL_ENV_DISABLE_PROMPT=1

  local black
  local blue
  local brown
  local cyan
  local green
  local magenta
  local purple
  local red
  local white
  local yellow
  # use extended color palette if available
  if [[ -n ${terminfo[colors]} && ${terminfo[colors]} -ge 256 ]]; then
    black='%F{0}'
    blue='%F{33}'
    brown='%F{166}'
    cyan='%F{37}'
    green='%F{64}'
    magenta='%F{134}'
    purple='%F{134}'
    red='%F{124}'
    white='%F{15}'
    yellow='%F{136}'
  else
    black='%F{black}'
    blue='%F{blue}'
    brown='%F{brown}'
    cyan='%F{cyan}'
    green='%F{green}'
    magenta='%F{magenta}'
    purple='%F{purple}'
    red='%F{red}'
    white='%F{white}'
    yellow='%F{yellow}'
  fi

  autoload -Uz add-zsh-hook
  autoload -Uz colors && colors

  prompt_opts=(cr percent sp subst)

  add-zsh-hook precmd prompt_senpai_precmd

  zstyle ':zim:git-info' verbose 'yes'
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:action' format "(${limegreen}%s%f)"
  zstyle ':zim:git-info:unindexed' format "${brown}●"
  zstyle ':zim:git-info:indexed' format "${green}●"
  zstyle ':zim:git-info:untracked' format "${red}●"
  zstyle ':zim:git-info:keys' format 'prompt' "${white}(%b%c%I%i%u%f)%s"
  PROMPT="${brown}%n%f in ${blue}%~%f\$(prompt_senpai_git)\$(prompt_senpai_virtualenv)\$(k8s_info)\$(aws_info) %(!.#.$) "
  RPROMPT=''
}

prompt_senpai_setup "$@"