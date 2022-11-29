run:
	docker build -t asterisk . && docker run -p 80:80 asterisk
push:
	docker compose -f docker-compose.build.yml build --compress --force-rm
	docker image tag zsu-cms-dev_cms:latest 31081991/zsu-cms
	docker push 31081991/zsu-cms
stop:
	docker stop asterisk && docker rm asterisk
console:
	docker exec -it asterisk bash
logs:
	docker logs asterisk