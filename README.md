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

1. Run workflow manually<br>
   1.1 Run **Backup. Create and push to artifacts**
   ```
   gh workflow run "Backup. Create and push to artifacts" --ref <branch_name>
   ```
   1.2 Run **Backend. Test, build and push to artifacts**
   ```
   gh workflow run "Backend. Test, build and push to artifacts" --ref <branch_name>
   ```
   1.3 Run **Nginx. Build and push to artifacts**
   ```
   gh workflow run "Nginx. Build and push to artifacts" --ref <branch_name>
   ```
   1.3 Run **Frontend. Test, build and push to artifacts**
   ```
   gh workflow run "Frontend. Test, build and push to artifacts" --ref <branch_name>
   ```