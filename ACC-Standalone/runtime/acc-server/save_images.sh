mkdir -p ./images

docker save acc_standalone:latest | gzip > ./images/acc_standalone.tar.gz