FROM pataquets/ubuntu:trusty

RUN \
	echo "deb http://deb.torproject.org/torproject.org $(lsb_release -cs) main" >> /etc/apt/sources.list && \
	gpg --keyserver keys.gnupg.net --recv 886DDD89 && \
	gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
		apt-get -y install \
			deb.torproject.org-keyring \
			tor \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mv /etc/tor/torrc /etc/tor/torrc.dpkg-dist

# Default ORPort
EXPOSE 9001

# Default DirPort 
EXPOSE 9030

# Default SOCKS5 proxy port 
EXPOSE 9050

# Default ControlPort
EXPOSE 9051
