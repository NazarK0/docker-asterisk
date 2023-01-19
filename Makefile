build:
	docker build -t asterisk-dev .
push:
	docker container commit asterisk-dev nazark0/asterisk:latest
	docker push nazark0/asterisk
