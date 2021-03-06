FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CODE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV DEBIAN_FRONTEND="noninteractive"

RUN \
 echo "**** install dependencies ****" && \
 apt-get update && \
 apt-get install -y \
	curl \
	dkms \
	gnupg \ 
	ifupdown \
	iproute2 \
	iptables \
	iputils-ping \
	libc6 \
	perl \
	qrencode && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1B39B6EF6DDB96564797591AE33835F504A1A25 && \
 echo "deb http://ppa.launchpad.net/wireguard/wireguard/ubuntu bionic main" >> /etc/apt/sources.list.d/wireguard.list && \
 echo "deb-src http://ppa.launchpad.net/wireguard/wireguard/ubuntu bionic main" >> /etc/apt/sources.list.d/wireguard.list && \
 echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections && \
 echo "REPORT_ABSENT_SYMLINK=no" >> /etc/default/resolvconf && \
 apt-get install resolvconf && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 51820/udp
