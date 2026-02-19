# Registry de la imagen

## 1. Construir la imagen
```shell
docker build -t verilator5042-uvm2017 .

# Successfully tagged verilator5042-uvm2017:latest
```
Listando las imágenes, debe estar presente

```shell
docker images

# REPOSITORY               TAG     IMAGE ID       CREATED       SIZE
# verilator5042-uvm2017    latest  b9421af0c7d3   3 hours ago   2.32GB
```

## 2. Tag al registry

```shell
docker tag verilator5042-uvm2017 registry.emtech.com.ar/cicd_template/fpga-ci-tools:verilator5042-uvm2017
```

## 3. Push al repositorio

```shell
docker push registry.emtech.com.ar/cicd_template/fpga-ci-tools:verilator5042-uvm2017

# The push refers to repository [registry.emtech.com.ar/cicd_template/fpga-ci-tools]
# ...
# verilator5042-uvm2017: digest: sha256:944...b89 size: 1789
```

----

# Update config.sh
See 'TODO' comments for places to customize for your project
