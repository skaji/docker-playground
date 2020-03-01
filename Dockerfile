FROM ubuntu:18.04

ADD build.sh /tmp/build.sh
RUN bash /tmp/build.sh

WORKDIR /home/skaji
USER skaji

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["tail", "-f", "/dev/null"]
