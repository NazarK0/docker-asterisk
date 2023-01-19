FROM debian:bullseye

RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive

RUN apt install --no-install-recommends -y libssl-dev libncurses-dev zlib1g-dev make gcc g++ libnewt-dev subversion linux-headers-$(uname -r) libxml2-dev libpq-dev
RUN apt install --no-install-recommends -y perl autoconf build-essential pkg-config m4 libtool automake autoconf wget libedit-dev uuid-dev libjansson-dev libsqlite3-dev

WORKDIR /app

# Install Dahdi
RUN wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz \
  && tar -zxvf dahdi-linux-complete-current.tar.gz \
  && rm -f dahdi-linux-complete-current.tar.gz \
  && cd dahdi-linux-complete-* \
  && make \
  && make install \
  && make config \
  && make install-config
# RUN /usr/local/src/ dahdi start

# Install libPRI
RUN apt install -y libpri1.4

# Install Asterisk
RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz \
  && tar -zxvf asterisk-20-current.tar.gz \
  && cd asterisk-20.* \
  && ./contrib/scripts/install_prereq install \
  && ./configure \
  && ./contrib/scripts/get_mp3_source.sh --non-interactive --trust-server-cert \
  && make menuselect.makeopts \
  && menuselect/menuselect \
  --enable-all \
  menuselect.makeopts \
  && make install \
  && make progdocs \
  && make samples \
  && make config \
  && ldconfig \
  && make install-logrotate

WORKDIR /
COPY docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]