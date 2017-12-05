# Senpai - 先輩
Senpai is a ZSH clean prompt theme for Devops

## Installation
### Install without any framework
If you just use a zsh without any framework, simply clone this repository and reference it in your ~/.zshrc:

```
$ git clone https://github.com/hiroru/senpai-zsh.git ~/.senpai-zsh
$ echo 'source  ~/.senpai-zsh/senpai.zsh-theme' >> ~/.zshrc
```

### Install for Oh-My-ZSH
To install this theme for use in Oh-My-Zsh, clone this repository into your OMZ custom/themes directory.

```
$ git clone https://github.com/hiroru/senpai-zsh.git ~/.oh-my-zsh/custom/themes/senpai-zsh
```
You then need to select this theme in your ~/.zshrc:

ZSH_THEME="senpai-zsh/senpai"

### Install for ZIM
To install this theme for use in ZIM, clone this repository into your ZIM prompt/external-themes directory.

```
$ git clone https://github.com/hiroru/senpai-zsh.git ~/.zim/modules/prompt/external-themes/senpai-zsh
$ ln -s ~/.zim/modules/prompt/external-themes/senpai-zsh/senpai.zsh-theme ~/.zim/modules/prompt/functions/prompt_senpai_setup
```
Add this at the beginning of your ~/.zshrc:

`SENPAI_INSTALLATION_PATH=~/.zim/modules/prompt/external-themes/senpai-zsh/senpai.zsh-theme`

You then need to select this theme in your ~/.zimrc:

`zprompt_theme='senpai'`

## ToDo
- Add color scheme to white console

## Changelog
### v0.1
- Initial release