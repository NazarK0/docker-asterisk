FROM debian:bullseye
WORKDIR /usr/local/src
COPY src .
RUN apt update && apt install -y make gcc linux-headers-$(uname -r) perl autoconf

# Install Dahdi
WORKDIR /usr/local/src/dahdi
RUN make && make install && make config

# Install libPRI
WORKDIR /usr/local/src/libpri
RUN make && make install

# Install Asterisk
WORKDIR /usr/local/src/asterisk
RUN ./configure
RUN make make distclean
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
