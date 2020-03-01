#!/bin/bash

set -eux

env DEBIAN_FRONTEND=noninteractive apt-get update
env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  curl \
  git \
  less \
  libbz2-dev \
  libncurses5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  locales-all \
  sudo \
  tzdata \
  unzip \
  vim \
  wget \
  xz-utils \
  zlib1g-dev \
  zsh \
  ;
apt-get autoremove -y
apt-get clean -y
rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

curl -fsSL -o /sbin/tini https://github.com/krallin/tini/releases/download/v0.18.0/tini
chmod +x /sbin/tini

useradd -G sudo -m -s /bin/zsh skaji
perl -i -nle 'if (/%sudo/) { print "%sudo ALL=(ALL) NOPASSWD: ALL" } else { print }' /etc/sudoers

su -l skaji -c '
  set -eux
  curl -fsSL https://git.io/perl-install | bash -s ~/perl
  export PATH=/home/skaji/perl/bin:$PATH
  curl -fsSL https://git.io/cpm > ~/perl/bin/cpm
  chmod 755 ~/perl/bin/cpm
  ~/perl/bin/cpm install -g IO::Socket::SSL
  rm -rf ~/.perl-cpm
  git clone https://bitbucket.org/skaji/dotfiles
  dotfiles/bin/__get_go.sh
  export GOPATH=$HOME
  go get golang.org/x/tools/cmd/goimports
  go get golang.org/x/lint/golint
  cd dotfiles
  perl setup.pl
'
