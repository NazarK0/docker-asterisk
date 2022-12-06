run:
	./preinstall.sh
	docker build -t nazark0/asterisk . && docker run --volume "$(pwd)"/configs:/usr/local/src/asterisk/configs/user-configs -p 80:80 --name asterisk-dev nazark0/asterisk 
push:
	docker container commit asterisk-dev nazark0/asterisk:latest
	docker push nazark0/asterisk
stop:
	docker stop asterisk-dev && docker rm asterisk-dev
console:
	docker exec -it asterisk-dev bash
logs:
	docker logs asterisk-dev