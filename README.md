# dotfiles

My personal dotfiles for a Fedora Workstation (GNOME) development machine, managed with [chezmoi](https://chezmoi.io).

One `chezmoi apply` takes a fresh install to a working setup: shell, git, terminal, prompt, GNOME settings and
the software I use. It is safe to run again at any time: it only adds what is missing and never uninstalls anything.

## Features

- **Shell:** zsh as login shell with [Oh My Zsh](https://ohmyz.sh) and the [Starship](https://starship.rs) prompt
- **Git:** sensible defaults, every commit and tag signed with an SSH key, stacked-branch aliases
- **Terminal:** [Ghostty](https://ghostty.org)
- **Software:** a single declarative list of dnf, COPR, Flatpak, cargo and uv packages
- **Toolchains:** rustup, [uv](https://docs.astral.sh/uv/), [Volta](https://volta.sh), Claude Code and JetBrains Toolbox
- **Docker:** Docker CE from the upstream repo, enabled at boot and usable without sudo
- **GNOME:** a curated set of settings applied with `dconf`
- **Layering:** drop-in points so a private repo (e.g. work config) can extend this one without forking it

## Requirements

- Fedora Workstation 41 or newer (dnf5), with GNOME. Most dotfiles work on any Linux, but the package scripts use dnf.
- A user with `sudo` rights. sudo is only asked for when something system-wide is missing.

## Installation

```sh
sudo dnf install -y chezmoi
chezmoi init --apply svenvnl/dotfiles
```

chezmoi asks once for your git name and email, then installs everything. Log out and back in afterwards to pick up
zsh as login shell and the `docker` group.

To preview first instead:

```sh
chezmoi init svenvnl/dotfiles
chezmoi diff
chezmoi apply
```

## Usage

| Task | Command |
|---|---|
| Pull and apply the latest changes | `chezmoi update` |
| See what would change | `chezmoi diff` |
| Edit a managed file | `chezmoi edit ~/.zshrc` |
| Update Oh My Zsh, uv and other downloads | `chezmoi apply --refresh-externals` |

## Repository layout

The chezmoi source state lives in [`home/`](home) (see [`.chezmoiroot`](.chezmoiroot)).

```text
home/
├── .chezmoi.toml.tmpl      # prompts for name/email on first init
├── .chezmoidata/
│   └── packages.yaml       # all software, as data
├── .chezmoiexternal.toml   # Oh My Zsh, uv, Volta: downloaded and kept up to date by chezmoi
├── .chezmoiscripts/        # installs packages, toolchains and GNOME settings
├── .chezmoitemplates/
│   └── dconf.ini           # curated GNOME settings
├── dot_config/             # ~/.config: ghostty, starship, git
├── dot_gitconfig.tmpl      # ~/.gitconfig
├── dot_zshrc, dot_zshenv, dot_zsh_aliases
└── private_dot_ssh/        # ~/.ssh/config and the public signing key
```

## Customizing

### Software

Everything that gets installed is listed in [`home/.chezmoidata/packages.yaml`](home/.chezmoidata/packages.yaml):
dnf packages and repositories, Flatpaks, cargo crates and uv tools. Add an entry and run `chezmoi apply`; the install
scripts rerun whenever the list changes. Removing an entry does not uninstall it.

Tools that are not packaged are handled separately:

- **Oh My Zsh, uv and Volta** are [chezmoi externals](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format/)
  in [`.chezmoiexternal.toml`](home/.chezmoiexternal.toml), refreshed weekly. Volta is pinned to a version; bump it there.
- **rustup, Claude Code and JetBrains Toolbox** update themselves, so they are only bootstrapped once.

### GNOME settings

[`home/.chezmoitemplates/dconf.ini`](home/.chezmoitemplates/dconf.ini) is loaded with `dconf load` on every change.
Only the keys listed there are set. To add one, change the setting in GNOME, find the key with `dconf watch /` and
copy it into the file.

### Commit signing

Git signs every commit and tag with `~/.ssh/id_ed25519_personal` through the ssh-agent. Only the public key is in this
repo; it is also used to build `~/.config/git/allowed_signers`, so `git log --show-signature` can verify signatures.
The private key is never managed: copy it to a new machine yourself.

## Layering

This repo is a public base layer. Private config, such as work settings, lives in a separate repo applied by a second
chezmoi instance and plugs into these hooks:

| Hook in this repo | Provided by a layer as |
|---|---|
| `~/.zshrc` sources `~/.config/zsh/conf.d/*.zsh` | `~/.config/zsh/conf.d/NN-name.zsh` |
| `~/.gitconfig` includes `~/.config/git/work.gitconfig` (ignored if missing) | that file, typically with `includeIf "gitdir:..."` |
| `~/.ssh/config` has `Include config.d/*` | `~/.ssh/config.d/name` |

A layer must never manage a file that this repo manages.

`~/.gitconfig.local` is included last and left unmanaged, for machine-local overrides. Don't set `user.signingkey`
there: it would also override a layer's key in that layer's repos.

## Using these dotfiles yourself

You're welcome to fork this repo or borrow parts of it. Before applying it as is, at least:

1. Replace `home/private_dot_ssh/id_ed25519_personal.pub` with your own public key
   (`ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_personal`), or turn off signing in `home/dot_gitconfig.tmpl`.
2. Review [`packages.yaml`](home/.chezmoidata/packages.yaml) and [`dconf.ini`](home/.chezmoitemplates/dconf.ini):
   they reflect my preferences, not yours.

## Acknowledgements

- [chezmoi](https://chezmoi.io) by Tom Payne
- [Pushing a whole stack of branches with a single git command](https://andrewlock.net/pushing-a-whole-stack-of-branches-with-a-single-git-command/)
  by Andrew Lock, the source of the `stack` and `push-stack` aliases

## License

[MIT](LICENSE)
