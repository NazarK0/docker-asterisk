build:
	docker build -t asterisk --build-arg VERSION=20.1.0 .
	docker tag asterisk nazark0/asterisk
push:
	docker image push nazark0/asterisk
