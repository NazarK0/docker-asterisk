FROM debian:bullseye
WORKDIR /usr/local/src
RUN  tar -zxf libpri-current.tar.gz .
RUN  tar -zxf dahdi-linux-complete-current.tar.gz .
RUN  tar -zxf asterisk-18-current.tar.gz .

# Install Dahdi
CD tar -zxvf asterisk-14-current.tar.gz
ENV PORT 80
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
EXPOSE ${PORT} 
