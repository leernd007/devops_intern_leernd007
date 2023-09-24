FROM nginx:latest

RUN apt-get update \
      && apt-get install -y git\
      && apt-get clean -qq \
      && apt-get autoclean -qq \
      && apt-get autoremove -qq \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD nginx.conf /etc/nginx/conf.d/default.conf
