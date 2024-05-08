
# Workspace Alias and Auto-Update Script for Zsh

## Overview
This script enhances your Zsh shell by automatically creating aliases for directories within your `~/workspace` up to three levels deep. Each alias not only opens the specified directory in Visual Studio Code but also attempts to perform a `git pull` to ensure the repository is up-to-date.

## Features
- **Automatic Alias Creation**: Automatically generates aliases for all directories from level 1 to level 3 within `~/workspace`. For example, `~/workspace/project/subdir` becomes accessible via the alias `project.subdir`.
- **Git Integration**: Before opening a directory in VS Code, the script checks if the directory is a Git repository. If it is, it attempts to update the repository using `git pull`.
- **Error Handling**: If `git pull` fails or the directory is not a Git repository, the script handles this gracefully, allowing you to proceed with your work without interruption.

## Installation
To integrate this script into your Zsh environment, follow these steps:

1. **Open Your Zsh Configuration**:
   Open your `.zshrc` file located in your home directory. You can open this file in a text editor by running:
   ```bash
   code ~/.zshrc  # Opens .zshrc in Visual Studio Code
   ```

2. **Copy and Paste the Script**:
   Copy the following function into your `.zshrc` file:

   ```zsh
   function generate_repo_aliases() {
       find ~/workspace -type d -mindepth 1 -maxdepth 3 ! -path '*/.*' ! -path '*/__pycache__/*' | while read -r dir; do
           if [ "$dir" != "$HOME/workspace" ]; then
               alias_name="${dir/$HOME\/workspace\//}"
               alias_name="${alias_name//\//.}"
               alias "$alias_name"="cd '$dir' && (git rev-parse --is-inside-work-tree > /dev/null 2>&1 && git pull || echo 'Not a git repository or git pull failed, proceeding anyway...') && code ."
           fi
       done
   }

   generate_repo_aliases

   autoload -U add-zsh-hook
   add-zsh-hook precmd generate_repo_aliases
   ```

3. **Reload Your Zsh Configuration**:
   To apply the changes, reload your `.zshrc` file by running:
   ```bash
   source ~/.zshrc
   ```

## Usage
Once installed, simply type the alias corresponding to the directory you wish to open. The script handles the rest, opening VS Code to the specified directory and ensuring that the repository is current. If the directory is not a Git repository or if the `git pull` fails, you will receive a notification but can continue to work normally.

## Customization
To exclude additional directories or adjust the depth of directories included, modify the `find` command parameters within the `generate_repo_aliases` function in your `.zshrc` file.
