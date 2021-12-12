UID := $(shell id -u)
GID := $(shell id -g)

export UID
export GID

default:
	echo "Default task not defined"
.PHONY: default


start:
	docker-compose up -d
.PHONY: start


stop:
	docker-compose down
.PHONY: stop


generate-certificate:
	mkcert -cert-file etc/traefik/certificates/_.demo.local.pem -key-file etc/traefik/certificates/_.demo.local-key.pem "*.demo.local"
	mkcert -cert-file etc/traefik/certificates/demo.local.pem -key-file etc/traefik/certificates/demo.local-key.pem "demo.local"
.PHONY: generate-certificate


composer-install:
	bin/composer install
.PHONY: composer-install


init: generate-certificate start composer-install
.PHONY: init

.SILENT:
