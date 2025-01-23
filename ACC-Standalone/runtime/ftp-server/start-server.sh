# docker run -it --rm -d -p 8080:80 --name web -v /Users/pillvin/workspace/capstone/design:/usr/share/nginx/html nginx

docker run \
	--detach \
	--env FTP_PASS=1234 \
	--env FTP_USER=one \
	--env PUBLIC_IP=127.0.0.1 \
	--name vinods-mbp \
	--publish 20-21:20-21/tcp \
	--publish 40000-40009:40000-40009/tcp \
	-v /Users/pillvin/workspace/capstone/design:/home/one \
	garethflowers/ftp-server

docker ps