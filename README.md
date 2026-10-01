# Dotfiles

Personal workstation configuration for the Workstation Platform and local Linux hosts.

## Install

The platform clones the repository into `~/.dotfiles` and runs `install.sh` on its first start. The installer links shell and Git configuration, installs the persistent `mise` tool baseline, and checks out fixed revisions of external Zsh plugins. To install manually:

```bash
./install.sh
```

The installer preserves an existing destination rather than overwriting it. Remove or move an existing file before rerunning it when you want this repository to take ownership.

## Contents

- `zsh/zshrc`: Oh My Zsh plugin configuration and Flux, Kubernetes, and Helm completions.
- `zsh/zshenv`: noninteractive environment hook for private exports.
- `zsh/p10k.zsh`: Powerlevel10k prompt configuration.
- `git/config`: shared Git defaults and aliases, with a local include for identity.

The installer pins the current development-tool baseline through `mise`: AWS, Azure, and Google Cloud CLIs; Kubernetes, Helm, and Flux; OpenTofu, Terraform, and Terragrunt; Go, Node, Python; GitHub CLI, `jq`, and `ripgrep`.

The installer checks out fixed revisions of external Oh My Zsh plugins into `~/.oh-my-zsh/custom/plugins`: Powerlevel10k, `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `kubecolor`. All other configured plugins are included with Oh My Zsh.

Keep AWS account identifiers, role names, credentials, tokens, and host-specific additions out of this repository. Add the AWS SSO configuration to the optional portal startup script with an append-only heredoc, then authenticate with:

```bash
aws sso login --sso-session lumeris-sso
```

Copy `git/config.local.example` to `~/.gitconfig.local` and set your Git identity. Use `~/.localenv` for private environment variables, `~/.zshrc.local.before` for interactive settings that must load before Oh My Zsh, and `~/.zshrc.local` for ordinary local shell additions.
# dotfiles
