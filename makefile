
build:
	./preinstall.sh && docker build -t asterisk .
run:
	docker run -p 80:80 asterisk
push:
	docker compose -f docker-compose.build.yml build --compress --force-rm
	docker image tag zsu-cms-dev_cms:latest 31081991/zsu-cms
	docker push 31081991/zsu-cms
stop:
	docker compose down --remove-orphans
db-console:
	docker exec -it db bash
cms-console:
	docker exec -it cms bash
cms-logs:
	docker logs cms