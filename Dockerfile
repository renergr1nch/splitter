FROM alpine:3.9

RUN apk add tor haproxy bash coreutils privoxy ncurses expect busybox-extras --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/3.9/community \
  --repository http://dl-cdn.alpinelinux.org/alpine/3.9/main \
    && rm -rf /var/cache/apk/* \
    && mkdir /splitter

ADD func /splitter/func
ADD splitter.sh /splitter/
RUN chmod 750 /splitter/splitter.sh

EXPOSE 63536
EXPOSE 63537

WORKDIR /splitter

ENTRYPOINT ["./splitter.sh", "-i 2", "-c 15", "-re exit"]
