FROM alpine

RUN apk update \
          && apk add git\
          && apk cache clean \
          && apk add --no-cache --upgrade bash \
          && apk add openssh-client \
          && apk add gawk \
          && apk add jq \
          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app
COPY . .

RUN mkdir -p ~/.ssh

CMD ["./backup.sh"]