FROM pataquets/ubuntu:trusty

RUN \
	apt-key adv --keyserver hkp://hkps.pool.sks-keyservers.net --recv-keys 886DDD89 && \
	echo "deb http://deb.torproject.org/torproject.org $(lsb_release -cs) main" >> /etc/apt/sources.list && \
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
