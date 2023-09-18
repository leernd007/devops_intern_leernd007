```
docker build -t devops_intern_leernd007_image --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" .
```

```
docker run -v $(pwd)/backup:/root/backup devops_intern_leernd007_image 3
```