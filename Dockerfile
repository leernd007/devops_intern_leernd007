FROM alpine

RUN apk update \
          && apk add git\
          && apk cache clean \
          && apk add --no-cache --upgrade bash \
          && apk add openssh-client gawk jq \
          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app
COPY ./backup.sh .


CMD ["./backup.sh"]