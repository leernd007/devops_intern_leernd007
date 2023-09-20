1. Build docker
```
docker build  --progress=plain  -t devops_intern_leernd007_image .
```

1. Run docker. <br>Put your private key into **~/.ssh/id_rsa**
```
docker run -v $(pwd)/backup:/root/backup --env SSH_PRV_KEY="$(cat ~/.ssh/id_rsa)" --env MAX_BACKUPS="3" --env BACKUP_RUNS="10" devops_intern_leernd007_image
```