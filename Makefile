run:
	./preinstall.sh && docker compose up --build
push:
	docker container commit asterisk-dev nazark0/asterisk:latest
	docker push nazark0/asterisk
stop:
	docker compose down --remove-orphans
console:
	docker exec -it asterisk-dev sh
logs:
	docker logs asterisk-dev