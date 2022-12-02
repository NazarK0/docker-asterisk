FROM debian:bullseye
WORKDIR /usr/local/src
COPY src .
RUN apt update && apt upgrade -y
RUN apt install -y libssl-dev libncurses-dev zlib1g-dev make gcc g++ libnewt-dev subversion linux-headers-$(uname -r) libxml2-dev
RUN apt install -y perl autoconf build-essential pkg-config m4 libtool automake autoconf wget libedit-dev uuid-dev libjansson-dev libsqlite3-dev

# Install Dahdi
WORKDIR /usr/local/src/dahdi
RUN make && make install && make config && make install-config

# Install libPRI
RUN apt install -y libpri1.4

# Install Asterisk
WORKDIR /usr/local/src/asterisk
RUN ./configure
RUN make && make distclean
WORKDIR /usr/local/src/asterisk/contrib/scripts
RUN ./install_prereq install
RUN ./install_prereq install-unpacked
RUN make menuselect
RUN make && make install
RUN make samples
RUN make config && make install-logrotate


ENV PORT 80
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
EXPOSE ${PORT} 

CMD [ "/etc/init.d/asterisk start", "run" ]
