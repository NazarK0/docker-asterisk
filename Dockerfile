FROM debian:bullseye
WORKDIR /usr/local/src
RUN  ./preinstall.sh
COPY --link src .

# Install Dahdi
WORKDIR /usr/local/src/dahdi
RUN make
RUN make install
RUN make config

# Install libPRI
WORKDIR /usr/local/src/libpri
RUN make
RUN make install

# Install Asterisk
WORKDIR /usr/local/src/asterisk
RUN ./configure
RUN make make distclean
WORKDIR /usr/local/src/asterisk/contrib/scripts
RUN ./install_prereq install
RUN ./install_prereq install-unpacked
RUN make menuselect

ENV PORT 80
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
EXPOSE ${PORT} 
