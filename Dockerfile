FROM debian:bullseye

# Install build dependencies
RUN apt update && apt upgrade -y
RUN apt install -y libssl-dev libncurses-dev zlib1g-dev make gcc g++ libnewt-dev subversion linux-headers-$(uname -r) libxml2-dev
RUN apt install -y perl autoconf build-essential pkg-config m4 libtool automake autoconf wget libedit-dev uuid-dev libjansson-dev libsqlite3-dev

# Install tools
RUN apt install kmod -y

WORKDIR /usr/local/src
COPY src .

# Install Dahdi
WORKDIR /usr/local/src/dahdi
RUN make && make install && make config && make install-config

# Install libPRI
RUN apt install -y libpri1.4

# Install Asterisk
WORKDIR /usr/local/src/asterisk/contrib/scripts
RUN ./get_mp3_source.sh
RUN ./install_prereq install
WORKDIR /usr/local/src/asterisk
RUN ./configure
RUN make menuselect
RUN make && make install
RUN make progdocs
RUN make samples && make config && ldconfig
RUN make install-logrotate
# RUN groupadd asterisk && useradd -r -d /var/lib/asterisk -g asterisk asterisk && usermod -aG audio,dialout asterisk
# RUN chown -R asterisk.asterisk /etc/asterisk && chown -R asterisk.asterisk /var/{lib,log,spool}/asterisk && chown -R asterisk.asterisk /usr/lib/asterisk
RUN mkdir /usr/local/src/asterisk/configs/user-configs

# Remove build dependencies
# RUN apt purge -y libssl-dev libncurses-dev zlib1g-dev make gcc g++ libnewt-dev subversion linux-headers-$(uname -r) libxml2-dev
# RUN apt purge -y perl autoconf build-essential pkg-config m4 libtool automake autoconf wget libedit-dev uuid-dev libjansson-dev libsqlite3-dev
RUN apt autoremove -y

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# SSH
EXPOSE 22/tcp
# GUI HTTP
EXPOSE 80/tcp
# GUI HTTPS
EXPOSE 443/tcp
# chan_PJSIP
EXPOSE 5060/udp
# chan_PJSIP
EXPOSE 5061
# chan_SIP
EXPOSE 5160/udp
# chan_SIP
EXPOSE 5161
# RTP
EXPOSE 10000-20000/udp
# IAX
EXPOSE 4569/udp

ADD asterisk /etc/asterisk

RUN invoke-rc.d dahdi start
RUN service asterisk start
# RUN lsmod | grep dahdi
# RUN asterisk -rvvvvvvvvvvvvvvvvvvv

ENTRYPOINT asterisk -cvvvvv
