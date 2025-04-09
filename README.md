# Menu

1. [Pimp My Vim](https://github.com/omersi/pimp_my_laptop#pimp-my-vim)
1. [Pimp My ZSH](https://github.com/omersi/pimp_my_laptop#pimp-my-zsh)
1. [Mac](https://github.com/omersi/pimp_my_laptop#mac)
    1. [Upgrade Bash](https://github.com/omersi/pimp_my_laptop#upgrade-bash-from-3-2-57-to-5-x)
    1. [Mofifier Keys](https://github.com/omersi/pimp_my_laptop#modifier-keys)
1. [IDE extensions](https://github.com/omersi/pimp_my_laptop#IDE-extensions)
1. [Kubernetes](https://github.com/omersi/pimp_my_laptop#Kubernetes)
2. [AWS Multiple Account SSO Login](https://github.com/omersi/pimp_my_laptop#Multiple-Account-SSO-Login)



----

## Pimp my Vim

* [ale](https://github.com/w0rp/ale) Asynchronous linting/fixing for Vim
* [dracula-theme](https://github.com/dracula/vim) A dark theme for Vim
* [fzf-vim](https://github.com/junegunn/fzf.vim) Things you can do with fzf and Vim NOTE: Requires** [fzf
* [neocomplete.vim](https://github.com/Shougo/neocomplete.vim) Next generation completion framework after neocomplcache
* [nerdtree](https://github.com/scrooloose/nerdtree) A tree explorer plugin for vim
* [the_silver_searcher](https://github.com/rking/ag.vim) Vim plugin for the_silver_searcher, 'ag' NOTE: Requires the_silver_searcher
* [undotree](https://github.com/mbbill/undotree) The ultimate undo history visualizer
* [vim-airline](https://github.com/vim-airline/vim-airline) lean & mean status/tabline for vim
* [vim-commentary](https://github.com/tpope/vim-commentary) comment stuff out easy peasy
* [vim-fugitive](https://github.com/tpope/vim-fugitive) A Git wrapper so awesome
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter) A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
* [vim-go](https://github.com/fatih/vim-go) Go development plugin for Vim
* [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors) True Sublime Text style multiple selections for Vim
* [vim-surround](https://github.com/tpope/vim-surround) Quoting/parenthesizing made simple
* [vim-terraform](https://github.com/hashivim/vim-terraform) Basic vim/terraform integration
* [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) Seamless navigation between tmux panes and vim splits
* [vim-yapf](https://github.com/mindriot101/vim-yapf) Python linter NOTE: Requires yapf
* [shellcheck](https://github.com/koalaman/shellcheck) ShellCheck, a static analysis tool for shell scripts

----

## Pimp my zsh

### Set PYTHONPATH when in poetry environment

```bash
# Update PYTHONPATH with the project directory when entering a Poetry environment
function poetry_enter() {
  local project_dir
  project_dir=$(poetry run python -c 'import os; print(os.path.dirname(os.path.realpath("pyproject.toml")))')

  if [[ -n "$project_dir" ]]; then
    # Check if any parent directory is already present in PYTHONPATH
    local parent_dir
    parent_dir=$project_dir
    while [[ "$parent_dir" != "/" ]]; do
      if [[ ":$PYTHONPATH:" == *":$parent_dir:"* ]]; then
        return
      fi
      parent_dir=$(dirname "$parent_dir")
    done

    export PYTHONPATH="$project_dir:$PYTHONPATH"
  fi
}

# Remove PYTHONPATH when exiting a Poetry environment
function poetry_exit() {
  unset PYTHONPATH
}

# Check if current or parent directory contains the pyproject.toml file
function is_in_poetry_project() {
  local dir
  dir=$PWD
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/pyproject.toml" ]]; then
      return 0
    fi
    dir=$(dirname "$dir")
  done
  return 1
}

# Hook into directory changes and activate/deactivate PYTHONPATH accordingly
function chpwd() {
  if is_in_poetry_project; then
    poetry_enter
  else
    poetry_exit
  fi
}
```

### iTerm Move cursor with ctrl + arrow keys

Set it to work using option (⌥) + arrows

```bash
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word
```

### Prefered Theme

* [Amuse](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes#amuse)
![amuse](https://cloud.githubusercontent.com/assets/2618447/6316861/70f3c4ce-ba03-11e4-88a5-0b423dd5a2ce.png "Amnuse screenshot")

### Plugins

* <https://www.freecodecamp.org/news/jazz-up-your-zsh-terminal-in-seven-steps-a-visual-guide-e81a8fd59a38/>
* [zsh](https://ohmyz.sh/) Your terminal never felt this good before
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) Framework for managing your zsh configuration
* [zsh-completions](https://github.com/zsh-users/zsh-completions) [Additional completion definitions for Zsh)
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) Fish shell like syntax highlighting for Zsh.
* [bat](https://github.com/sharkdp/bat) A cat(1) clone with wings
* [Automaticaly switch to Vevn](https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv)

### Modern Unix

* Cool tools that helps making the terminal even better [modern-unix](https://github.com/ibraheemdev/modern-unix)

### Aliases

```bash
alias lql='ls -lA *sql'
alias hg='history | grep'
alias pd='$HOME/workspace/scripts/pd.sh'
alias cat='bat'
#alias python='python3'
alias ipython='ipython3'
alias ptp='ptpython3'
alias stree='tree -I \'igore1|ignore2|ignore3_*\''
```

----

### FZF

```bash
### fzf ############################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='-m --color fg:-1,bg:-1,hl:120,fg+:3,bg+:233,hl+:229 --color info:140,prompt:120,spinner:150,pointer:167,marker:174'
 # fe - Open the selected files with the default editor
fe() {
   local files=$(fzf --query="$1" --select-1 --exit-0 | sed -e "s/\(.*\)/\'\1\'/")
   local command="${EDITOR:-vim} -p $files"
   [ -n "$files" ] && eval $command
}
```

#### fag - find an argument with ag and fzf and open with vim
```bash
fag () {
	local dir_pattern=""
	local search_args=()
	local ignore_args=()
	local arg_parse_ignore=false
	while [[ "$1" =~ ^- && ! "$1" == "--" ]]
	do
		case $1 in
			(-h) echo "Usage: fag [options] search_term -- ignore_pattern1 ignore_pattern2 ..."
				echo "Options:"
				echo "  -h            Show this help message and exit."
				echo "  -d            Specify a custom directory pattern to search within."
				return ;;
			(-d) shift
				dir_pattern="$1"  ;;
		esac
		shift
	done
	if [[ "$1" == "--" ]]
	then
		shift
	fi
	while [[ $# -gt 0 ]]
	do
		if [[ $1 == "--" ]]
		then
			arg_parse_ignore=true
			shift
			continue
		fi
		if [[ $arg_parse_ignore == true ]]
		then
			ignore_args+=("--ignore='$1'")
		else
			search_args+=("$1")
		fi
		shift
	done
	if [ ${#search_args[@]} -eq 0 ]
	then
		echo "Error: No query. What do you want to search for?"
		return
	fi
	local search_dirs=("$HOME/workspace" "$HOME/Downloads" "$HOME/Documents" "$HOME/.scripts")
	local search_command="ag --nogroup --color"
	for i in "${ignore_args[@]}"
	do
		search_command+=" $i"
	done
	search_command+=" '${search_args[@]}' ${search_dirs[@]}"
	echo "Running command: $search_command"
	local out=$(eval $search_command | fzf --ansi --delimiter=':' --with-nth=1,2 --preview="bat --color=always --style=numbers,grid --highlight-line {2} --paging=always --pager 'less +{2}' {1}" --preview-window=right:50%:nowrap)
	if [[ -n "$out" ]]
	then
		local file=$(echo "$out" | cut -d':' -f1)
		local line=$(echo "$out" | cut -d':' -f2)
		echo "Opening $file at line $line..."

		# Determine the two-level parent workspace directory manually
		local workspace_dir=$(dirname "$file" | sed -E 's|^('$HOME'/workspace/[^/]+/[^/]+).*$|\1|')

		# If workspace is already open for this directory, add to the workspace
		local is_workspace_open=$(ps aux | grep "code.*$workspace_dir" | grep -v grep)
		if [[ -n "$is_workspace_open" ]]
		then
			# Add the file to the already opened workspace
			code --add "$file" --goto "$file:$line"
		else
			# Open a new workspace window for the specific workspace directory
			code "$workspace_dir" --goto "$file:$line"
		fi
	else
		echo "No file selected."
	fi
}
```

## Other Stuff

* Change your PS1 [BashRC Generator](http://bashrcgenerator.com)
* Configure crontab schedule [Crontab Guru](https://crontab.guru)

----

### pd.sh

```bash
#!/bin/bash
export LC_ALL=C
head /dev/urandom | tr -dc 'A-Za-z0-9"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c 30 ; echo ''
```

----

## Mac 

### Upgrade bash from 3.2.57 to 5.x

Mac comes with `bash 3.2.57` due to licensing issues. in order to upgrade to the latest version (5.1.12 / Dec, 2021), run

```bash
brew install bash
newbash="$(echo $(brew --prefix)/bin/bash | sudo tee -a /private/etc/shells)"
sudo chpass -s $newbash
```

### Modifier Keys

When using mac with external keyboard, it's best to modify the keys to comply with Mac layout.
I set this way:

* Caps Lock > Caps Lock
* Control > Control
* Option > Command
* Command > Option
* Function > fn \(function)

Make sure to select the correct keyboard on the upper drop down menu.

![Modify Keys](mac_modifier_keys.png)

----

## IDE extensions

* [Tabnine](https://www.tabnine.com/welcome/) - TabNine uses deep learning to help you write code faster.

----

## Kubernetes

* K3s - Lightweight Kubernetes <https://k3s.io>
* K9s -  [Kubernetes CLI To Manage Your Clusters In Style](https://github.com/derailed/k9s)
* PGcli -  [Pgcli is a command line interface for Postgres with auto-completion and syntax highlighting.](https://www.pgcli.com/)

## AWS

### Multiple Account SSO Login
Based on https://medium.com/@RDarrylR/aws-sso-credentials-with-multiple-accounts-9a8466ca244d

Generate `~/.aws/config` file where every profile uses the same `sso_session`

```ini
[default]
region = us-east-1
output = json

# Shared SSO session
[sso-session devops-session]
sso_start_url = https://your-sso-start-url.awsapps.com/start
sso_region = us-east-1
sso_registration_scopes = sso:account:access

# Central shared services account (primary login)
[profile shared-services]
sso_session = devops-session
sso_account_id = 111111111111
sso_role_name = DevOpsAccess
region = us-east-1
output = json

# Development account
[profile dev]
sso_session = devops-session
sso_account_id = 222222222222
sso_role_name = DeveloperAccess
region = us-east-1
output = json

# Production account
[profile prod]
sso_session = devops-session
sso_account_id = 333333333333
sso_role_name = ReadOnlyAccess
region = us-east-1
output = json

# Optional: Additional environments
[profile staging]
sso_session = devops-session
sso_account_id = 444444444444
sso_role_name = DeveloperAccess
region = us-east-1
output = json
```

Login with 
```bash
aws sso login --profile shared-services
```

Test 
```bash
aws s3 ls --profile dev
aws sts get-caller-identity --profile prod
```

