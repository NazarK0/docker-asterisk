run:
	docker build -t nazark0/asterisk . && docker run -p 80:80 --name asterisk nazark0/asterisk
push:
	docker container commit asterisk nazark0/asterisk:latest
	docker push nazark0/asterisk
stop:
	docker stop asterisk && docker rm asterisk
console:
	docker exec -it asterisk bash
logs:
	docker logs asterisk