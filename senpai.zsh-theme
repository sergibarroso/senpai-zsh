# Senpai
# by Sergi Barroso
# https://github.com/hiroru/senpai-zsh
# MIT License

k8s_info() {
  if [ -f "$HOME/.kube/config" ]; then
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

azure_info() {
  if [ -f "$HOME/.azure/config" ]; then
    azure_cloud=$(awk '/name/{print tolower($3)}' $HOME/.azure/config)
    if [ ! -z ${azure_cloud} ]; then
      echo " %F{45}ⓐ ${azure_cloud}%f"
    fi
  fi
}

gcp_info() {
  if [ -f "$HOME/.config/gcloud/active_config" ]; then
    gcp_profile=$(cat $HOME/.config/gcloud/active_config)
    gcp_project=$(awk '/project/{print $3}' $HOME/.config/gcloud/configurations/config_$gcp_profile)
    if [ ! -z ${gcp_project} ]; then
      echo " %F{34}ⓖ ${gcp_project}%f"
    fi
  fi
}

define_var() {
  local varname="$1"
  typeset -p "$varname" > /dev/null 2>&1
}

set_default() {
  local varname="$1"
  local default_value="$2"
  define_var "$varname"  || typeset -g "$varname"="$default_value"
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

prompt_senpai_time() {
  print -n "[%F{white}%*] "
}

prompt_senpai_setup() {
  
  # Set default values
  [[ -n ${VIRTUAL_ENV} ]] && export VIRTUAL_ENV_DISABLE_PROMPT=1
  set_default SENPAI_SHOW_TIME  true
  set_default SENPAI_SHOW_USER  true
  set_default SENPAI_SHOW_PATH  true
  set_default SENPAI_SHOW_GIT   true
  set_default SENPAI_SHOW_K8S   true
  set_default SENPAI_SHOW_AWS   true
  set_default SENPAI_SHOW_GCP   true
  set_default SENPAI_SHOW_AZURE true

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

  # Init PROMPT
  PROMPT=""

  # Build prompt based on user settings
  # Do not print timestamp if it is disabled
	if [[ $SENPAI_SHOW_TIME == true ]]; then
		PROMPT+="\$(prompt_senpai_time)"
	fi

  # Do not print user if it is disabled
	if [[ $SENPAI_SHOW_USER == true ]]; then
		PROMPT+="${brown}%n%f"
	fi

  # Do not print path if it is disabled
	if [[ $SENPAI_SHOW_USER == true ]] && [[ $SENPAI_SHOW_PATH == true ]]; then
		PROMPT+=" in ${blue}%~%f"
	elif [[ $SENPAI_SHOW_PATH == true ]]; then
    PROMPT+="${blue}%~%f"
  fi

  # Do not print git status if it is disabled
	if [[ $SENPAI_SHOW_GIT == true ]]; then
		PROMPT+="\$(prompt_senpai_git)"
	fi

  # Do not print virtual env if it is disabled
	if [[ $SENPAI_SHOW_VIRT == true ]]; then
		PROMPT+="\$(prompt_senpai_virtualenv)"
	fi

  # Do not print virtual env if it is disabled
	if [[ $SENPAI_SHOW_K8S == true ]]; then
		PROMPT+="\$(k8s_info)"
	fi

  # Do not print virtual env if it is disabled
	if [[ $SENPAI_SHOW_AWS == true ]]; then
		PROMPT+="\$(aws_info)"
	fi

  # Do not print virtual env if it is disabled
	if [[ $SENPAI_SHOW_GCP == true ]]; then
		PROMPT+="\$(gcp_info)"
	fi

  # Do not print virtual env if it is disabled
	if [[ $SENPAI_SHOW_AZURE == true ]]; then
		PROMPT+="\$(azure_info)"
	fi
  
  # Add the final prompt
  PROMPT+=" %(?.%F{white}.%F{red})❯%f "
  RPROMPT=''
}

prompt_senpai_setup "$@"