#!/usr/bin/env bash
# Installs only absent files so existing workstation customization is preserved.
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
omz="$HOME/.oh-my-zsh"

link_if_absent() {
	local source=$1
	local destination=$2

	if [[ -e "$destination" || -L "$destination" ]]; then
		printf 'Keeping existing %s\n' "$destination"
		return
	fi

	mkdir -p "$(dirname "$destination")"
	ln -s "$source" "$destination"
	printf 'Linked %s\n' "$destination"
}

# A user-owned clone so `omz update` works without root.
install_oh_my_zsh() {
	[[ -d "$omz/.git" ]] && return
	rm -rf "$omz.new"
	if ! git clone --quiet --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$omz.new"; then
		printf 'Unable to install Oh My Zsh\n' >&2
		rm -rf "$omz.new"
		return 1
	fi
	# Keep plugins and themes that were installed before Oh My Zsh itself.
	if [[ -d "$omz/custom" ]]; then
		cp -a "$omz/custom/." "$omz.new/custom/"
	fi
	rm -rf "$omz"
	mv "$omz.new" "$omz"
}

install_custom() {
	local kind=$1
	local name=$2
	local repository=$3
	local revision=$4
	local destination="$omz/custom/$kind/$name"

	[[ -d "$destination/.git" ]] && return
	mkdir -p "$(dirname "$destination")"
	if ! git init --quiet "$destination" \
		|| ! git -C "$destination" remote add origin "$repository" \
		|| ! git -C "$destination" fetch --depth 1 origin "$revision" \
		|| ! git -C "$destination" checkout --quiet --detach FETCH_HEAD; then
		printf 'Unable to install Zsh %s %s\n' "$kind" "$name" >&2
		rm -rf "$destination"
	fi
}

install_tool() {
	local tool=$1
	local version=$2

	if ! mise use --global "${tool}@${version}"; then
		printf 'Unable to install %s@%s\n' "$tool" "$version" >&2
	fi
}

install_oh_my_zsh
install_custom plugins zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git 85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5
install_custom plugins zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git 0bfcb582e71d3abe604ce67bc0fe5a21f377507e
install_custom themes powerlevel10k https://github.com/romkatv/powerlevel10k.git d05a1b00f9a61f9578bf9dc19b8451942dde8734

link_if_absent "$repo_root/zsh/zshrc" "$HOME/.zshrc"
link_if_absent "$repo_root/zsh/p10k.zsh" "$HOME/.p10k.zsh"
link_if_absent "$repo_root/zsh/zshenv" "$HOME/.zshenv"
link_if_absent "$repo_root/git/config" "$HOME/.gitconfig"

# Matches the current Linux development server's portable tool baseline.
install_tool awscli 2.33.15
install_tool uv latest
install_tool azure-cli latest
install_tool gcloud 577.0.0
install_tool kubectl latest
install_tool kubecolor latest
install_tool helm latest
install_tool flux2 latest
install_tool opentofu 1.12.6
install_tool terraform 1.15.8
install_tool terragrunt 1.1.2
install_tool go latest
install_tool node 20
install_tool python 3.12
install_tool github-cli latest
install_tool jq 1.8.1
install_tool ripgrep 14.1.1
