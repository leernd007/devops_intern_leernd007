```
docker build  --progress=plain  -t devops_intern_leernd007_image .
```

```
docker run -v $(pwd)/backup:/root/backup --env ssh_prv_key="$(cat ~/.ssh/id_rsa)" --env max_backups="3" --env backup_runs="10" devops_intern_leernd007_image
```