FROM ubuntu

RUN set -eux; \
  apt-get update; \
  apt-get -y install \
    build-essential \
    bzip2 \
    curl \
    dnsutils \
    git \
    gzip \
    iproute2 \
    iptables \
    iputils-ping \
    libssl-dev \
    libz-dev \
    lsof \
    net-tools \
    netcat \
    tar \
    telnet \
    vim \
    wget \
    xz-utils \
  ; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/*; \
  curl -fsSL -o /sbin/tini https://github.com/krallin/tini/releases/download/v0.18.0/tini; \
  chmod +x /sbin/tini; \
  curl -fsSL https://git.io/perl-install | bash -s /usr/local/; \
  curl -fsSL https://git.io/cpm -o /usr/local/bin/cpm; \
  chmod +x /usr/local/bin/cpm; \
  change-shebang -f /usr/local/bin/cpm; \
  cpm install -g IO::Socket::SSL; \
  rm -rf ~/.perl-cpm; \
  :

WORKDIR /root

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["sleep", "infinity"]
