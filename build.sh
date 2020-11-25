#!/bin/bash

set -eux

env DEBIAN_FRONTEND=noninteractive apt-get update
env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  curl \
  dstat \
  gdb \
  git \
  less \
  libbz2-dev \
  libncurses5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  locales-all \
  net-tools \
  strace \
  sudo \
  tzdata \
  unzip \
  wget \
  xz-utils \
  zlib1g-dev \
  zsh \
  ;
apt-get autoremove -y
apt-get clean -y
rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

echo Asia/Tokyo >/etc/timezone
rm -f /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

curl -fsSL -o /sbin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini
chmod +x /sbin/tini

useradd -G sudo -m -s /bin/zsh skaji
perl -i -nle 'if (/%sudo/) { print "%sudo ALL=(ALL) NOPASSWD: ALL" } else { print }' /etc/sudoers

su -l skaji -c '
  set -eux
  curl -fsSL https://git.io/perl-install | bash -s ~/perl
  curl -fsSL https://git.io/cpm -o ~/perl/bin/cpm
  chmod 755 ~/perl/bin/cpm
  ~/perl/bin/change-shebang -f ~/perl/bin/cpm
  ~/perl/bin/cpm install -g IO::Socket::SSL JSON::XS
  rm -rf ~/.perl-cpm
  git clone https://bitbucket.org/skaji/dotfiles
  dotfiles/bin/__get_go.sh
  export GOPATH=$HOME
  ~/env/go/bin/go get golang.org/x/tools/cmd/goimports
  ~/env/go/bin/go get golang.org/x/lint/golint
  dotfiles/bin/__build_vim.sh
  rm -rf ~/src
  env PATH=$HOME/bin:$HOME/local/bin:$HOME/dotfiles/bin:$PATH ~/perl/bin/perl dotfiles/setup.pl
'
