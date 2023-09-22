<h3>DO_1</h3>

1. Build docker
```
docker build  --progress=plain  -t devops_intern_leernd007_image .
```

2. Run docker. <br>Put your private key into **~/.ssh/id_rsa**
```
docker run -v $PWD/backup:/root/backup --env SSH_PRV_KEY="$(cat ~/.ssh/id_rsa)" --env MAX_BACKUPS="3" --env BACKUP_RUNS="10" devops_intern_leernd007_image
``` 

<h3>DO_2</h3>

1. In console run command:
```
docker-compose  up --build
```

2. In a browser open:
```
http://localhost
```
3. Congratulations.<br>
   ![screen](./screenshots/img.png)


<h3>DO_3</h3>

1. Run workflow manually, check workflow button