FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y \
        git

RUN mkdir ~/.ssh
ARG ssh_prv_key
WORKDIR /app
COPY ./backup.sh .
RUN echo "$ssh_prv_key" > ~/.ssh/id_rsa && \
    chmod 600 ~/.ssh/id_rsa && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    git clone git@github.com:leernd007/devops_intern_leernd007.git && \
    rm ~/.ssh/id_rsa


ENTRYPOINT ["./backup.sh", "--max-backups"]
CMD ["5"]