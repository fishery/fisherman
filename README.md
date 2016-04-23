[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square

[organization]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[online]: http://fisherman.sh/#search

[Español]: docs/es-ES
[简体中文]: docs/zh-CN
[日本語]: docs/jp-JA

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fisherman is a zero-configuration, concurrent plugin manager for the [fish shell].

Read this document in another language: [Español], [日本語], [简体中文].

## Why?

* Simple

* No configuration

* No external dependencies

* No impact on shell startup time

* Use it interactively or _a la_ vundle

* Only the essentials, install, update, remove, list and help

## Install

Copy `fisher.fish` into your `~/.config/fish/functions` directory and that's it.

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## Usage

Install a plugin.

```
fisher simple
```

Install from multiple sources.

```
fisher z fzf omf/{grc,thefuck}
```

Install from a URL.

```
fisher https://github.com/edc/bass
```

Install from a gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Install from a local directory.

```sh
fisher ~/my_aliases
```

Use it a la vundle. Edit your fishfile and run `fisher` to satisfy changes.

> [What is a fishfile and how do I use it?](#9-what-is-a-fishfile-and-how-do-i-use-it)

```sh
$EDITOR fishfile # add plugins
fisher
```

See what's installed.

```
fisher ls
@ my_aliases    # this plugin is a local directory
* simple        # this plugin is the current prompt
  bass
  fzf
  grc
  thefuck
  z
```

Update everything.

```
fisher up
```

Update some plugins.

```
fisher up bass z fzf thefuck
```

Remove plugins.

```
fisher rm simple
```

Remove all the plugins.

```
fisher ls | fisher rm
```

Get help.

```
fisher help z
```

## FAQ

### 1. What fish version is required?

fisherman was built for the latest fish, but at least 2.2.0 is required. If you can't upgrade your build, append the following code to your `~/.config/fish/config.fish` for [snippet](#12-what-is-a-plugin) support.

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. How do I install fish on OS X?

With [Homebrew][Homebrew].

```
brew install fish
```

### 3. How do I install the latest fish on some Linux?

#### Debian

```sh
wget http://download.opensuse.org/repositories/shells:fish:release:2/Debian_8.0/Release.key
apt-key add - < Release.key
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_8.0/ /' >> /etc/apt/sources.list.d/fish.list
apt-get update
apt-get install fish
```

#### Ubuntu

```sh
sudo apt-add-repository ppa:fish-shell/release-2
sudo apt-get update
sudo apt-get install fish
```

#### CentOS

```sh
cd /etc/yum.repos.d/
wget http://download.opensuse.org/repositories/shells:fish:release:2/CentOS_7/shells:fish:release:2.repo
yum install fish
```

#### Fedora

```sh
cd /etc/yum.repos.d/
wget http://download.opensuse.org/repositories/shells:fish:release:2/Fedora_23/shells:fish:release:2.repo
yum install fish
```

#### Arch Linux

```sh
pacman -S fish
```

#### Gentoo

```sh
emerge fish
```

#### From source

```sh
sudo apt-get -y install git gettext automake autoconf \
    ncurses-dev build-essential libncurses5-dev

git clone -q --depth 1 https://github.com/fish-shell/fish-shell
cd fish-shell
autoreconf && ./configure
make && sudo make install
```

### 4. How do I use fish as my default shell?

Add fish to the list of login shells in `/etc/shells` and make it your default shell.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 5. How do I uninstall fisherman?

Run

```fish
fisher self-uninstall
```

### 6. Is fisherman compatible with oh my fish themes and plugins?

Yes.

### 7. Why fisherman? Why not ____?

fisherman has / is:

* small and fits in one file

* zero impact on shell startup time

* fast and easy to install, update and uninstall

* no need to edit your fish configuration

* correct usage of the XDG base directory spec

### 8. Where does fisherman put stuff?

fisherman goes in `~/.config/fish/functions/fisher.fish`.

The cache and plugin configuration is created in `~/.cache/fisherman` and `~/.config/fisherman` respectively.

The fishfile is saved to `~/.config/fish/fishfile`.

### 9. What is a fishfile and how do I use it?

The fishfile `~/.config/fish/fishfile` lists all the installed plugins.

You can let fisherman take care of this file for you automatically, or write in the plugins you want and run `fisher` to satisfy the changes.

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

This mechanism only installs plugins and missing dependencies. To remove a plugin, use `fisher rm` instead.

### 10. Where can I find a list of fish plugins?

Browse the [organization] or use the [online] search to discover content.

### 11. How do I upgrade from ____?

fisherman does not interfere with any known frameworks. If you want to uninstall oh my fish, refer to their documentation.

### 12. What is a plugin?

A plugin is:

1. a directory or git repo with a function `.fish` file either at the root level of the project or inside a `functions` directory

2. a theme or prompt, i.e, a `fish_prompt.fish`, `fish_right_prompt.fish` or both files

3. a snippet, i.e, one or more `.fish` files inside a directory named `conf.d` that are evaluated by fish at the start of the shell

### 13. How can I list plugins as dependencies to my plugin?

Create a new `fishfile` file at the root level of your project and write in the plugin dependencies.

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```

### 14. What about fundle?

fundle inspired me to use a bundle file, but it still has limited capabilities and requires you to modify your fish configuration.

### 15. I have a question or request not addressed here. Where should I put it?

Create a new ticket on the issue tracker:

* https://github.com/fisherman/fisherman/issues

[Homebrew]: http://brew.sh
