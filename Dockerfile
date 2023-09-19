FROM alpine

RUN apk update \
          && apk add git\
          && apk cache clean \
          && apk add --no-cache --upgrade bash \
          && apk add openssh-client \
          && apk add gawk \
          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#ARG ssh_prv_key
WORKDIR /app
COPY . .
#RUN echo "$ssh_prv_key" > ~/.ssh/id_rsa && \
#    chmod 600 ~/.ssh/id_rsa && \
#    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
#    git clone git@github.com:leernd007/devops_intern_leernd007.git && \
#    rm ~/.ssh/id_rsa
RUN mkdir -p ~/.ssh

ENTRYPOINT ["./backup.sh", "--max-backups"]
CMD ["5"]