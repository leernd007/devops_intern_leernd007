FROM alpine

RUN apk update \
          && apk add git\
          && apk cache clean \
          && apk add --no-cache --upgrade bash \
          && apk add openssh-client \
          && apk add gawk \
          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app
COPY . .

RUN mkdir -p ~/.ssh

ENTRYPOINT ["./backup.sh", "--max-backups"]
CMD ["5"]