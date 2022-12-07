FROM debian:bullseye

RUN apt-get update

RUN apt install --no-install-recommends -y libssl-dev libncurses-dev zlib1g-dev make gcc g++ libnewt-dev subversion linux-headers-$(uname -r) libxml2-dev
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

# RUN apt-get install --no-install-recommends -y \
#   libncurses-dev libz-dev libxml2-dev libsqlite3-dev uuid-dev uuid libjansson-dev \
#   libsnmp-dev libiksemel-dev libical-dev libspandsp-dev libsrtp-dev

# Install Asterisk
RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz \
  && tar -zxvf asterisk-20-current.tar.gz \
  && rm -f asterisk-20-current.tar.gz \
  && cd asterisk-20.*/contrib/scripts \
  # && ./get_mp3_source.sh \
  && ./install_prereq install \
  && cd ../.. \
  && ./configure NOISY_BUILD=yes \
  && make menuselect.makeopts \
  && menuselect/menuselect \
  --enable CORE-SOUNDS-EN-WAV \
  --enable CORE-SOUNDS-EN-G722 \
  --enable CORE-SOUNDS-EN-ULAW \
  --enable CORE-SOUNDS-EN-GSM \
  --enable MOH-OPSOUND-WAV \
  --enable MOH-OPSOUND-G722 \
  --enable MOH-OPSOUND-ULAW \
  --enable MOH-OPSOUND-GSM \
  --enable EXTRA-SOUNDS-EN-WAV \
  --enable EXTRA-SOUNDS-EN-G722 \
  --enable EXTRA-SOUNDS-EN-ULAW \
  --enable EXTRA-SOUNDS-EN-GSM \
  menuselect.makeopts \
  && make install \
  && make progdocs \
  && make samples \
  && make config \
  && ldconfig \
  && make install-logrotate

WORKDIR /var/lib/asterisk/sounds

RUN wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz \
  && tar xfz asterisk-extra-sounds-en-wav-current.tar.gz \
  && rm -f asterisk-extra-sounds-en-wav-current.tar.gz

RUN wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-g722-current.tar.gz \
  && tar xfz asterisk-extra-sounds-en-g722-current.tar.gz \
  && rm -f asterisk-extra-sounds-en-g722-current.tar.gz

RUN wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-ulaw-current.tar.gz \
  && tar xfz asterisk-extra-sounds-en-ulaw-current.tar.gz \
  && rm -f asterisk-extra-sounds-en-ulaw-current.tar.gz

RUN wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-gsm-current.tar.gz \
  && tar xfz asterisk-extra-sounds-en-gsm-current.tar.gz \
  && rm -f asterisk-extra-sounds-en-gsm-current.tar.gz

ADD asterisk /etc/asterisk

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

ENTRYPOINT asterisk -cvvvvv