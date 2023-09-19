```
docker build  --progress=plain  -t devops_intern_leernd007_image .
```

```
docker run -v $(pwd)/backup:/root/backup --env ssh_prv_key="$(cat ~/.ssh/id_rsa)" devops_intern_leernd007_image 3
```