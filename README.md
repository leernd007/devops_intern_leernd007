<h3>DO_1. Backups creation</h3>
2. Build docker
```
docker build  --progress=plain  -t devops_intern_leernd007_image .
```

1. Run docker. <br>Put your private key into **~/.ssh/id_rsa**
```
docker run -v $PWD/backup:/root/backup --env SSH_PRV_KEY="$(cat ~/.ssh/id_rsa)" --env MAX_BACKUPS="3" --env BACKUP_RUNS="10" devops_intern_leernd007_image
``` 

<h3>DO_2. APP</h3>
```
docker-compose up -d
```
```
docker exec -it nginx sh
```
```
docker exec -it frontend sh
```
```
sudo lsof -i -P -n | grep LISTEN
```