FROM node:0.10.40
MAINTAINER Barry Teoh <barry@kuggle.rocks>

RUN apt-get update -qq && \
    npm install -g coffee-script && \
    ln -s /usr/bin/nodejs /usr/bin/node

# Install MongoDB Client
RUN apt-get install -y mongodb-clients supervisor openssh-server
RUN mkdir -p /var/run/sshd /var/log/supervisor

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# simple tests
RUN coffee --version

COPY . /src
RUN cd /src; npm install

EXPOSE 3000

CMD ["/usr/bin/supervisord"]
