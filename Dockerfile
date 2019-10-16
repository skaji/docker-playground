FROM nicolaka/netshoot

RUN set -eux; \
  apk add --update --no-cache \
    bash \
    build-base \
    ca-certificates \
    openssl-dev \
    perl \
    perl-dev \
    procps \
    tini \
    tzdata \
    zlib-dev \
  ; \
  echo "alias ll='ls -al'" >> ~/.bashrc; \
  echo "PS1='\u@\h:\w\\\$ '"  >> ~/.bashrc; \
  cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime; \
  echo Asia/Tokyo > /etc/timezone; \
  curl -fsSL -o /usr/local/bin/cpm https://git.io/cpm; \
  chmod +x /usr/local/bin/cpm; \
  cpm install -g --show-build-log-on-failure IO::Socket::SSL; \
  rm -rf ~/.perl-cpm; \
  :

WORKDIR /root

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["tail", "-f", "/dev/null"]
