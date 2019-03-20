FROM pataquets/ubuntu:xenial

# Temporarily install 'curl', fetch Tor Project GPG signing keys and import them into apt keyring.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      curl \
  && \
  curl --silent --location \
    https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc \
  | gpg --import \
  && \
  gpg --fingerprint 0xEE8CBC9E886DDD89 && \
  gpg --export 0xEE8CBC9E886DDD89 | apt-key add - \
  && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y purge \
      curl \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN \
  echo "deb https://deb.torproject.org/torproject.org xenial main" \
    | tee /etc/apt/sources.list.d/tor.list \
  && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      deb.torproject.org-keyring \
      obfsproxy \
      tor \
      tor-arm \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN \
  mkdir -vp /etc/tor/conf-enabled/ && \
  mv /etc/tor/torrc /etc/tor/torrc.dpkg-dist

ADD files/etc/tor /etc/tor/

# Default ORPort
EXPOSE 9001

# Default DirPort
EXPOSE 9030

# Default SOCKS5 proxy port
EXPOSE 9050

# Default ControlPort
EXPOSE 9051

CMD [ "tor" ]
