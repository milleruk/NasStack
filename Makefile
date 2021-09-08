SHELL = bash
.DEFAULT_GOAL := help
PWD := $(shell pwd)
FILES := $(shell for file in stacks/enabled/*.yml; do command+=" -f $$file"; done; echo $$command)

help:
	@echo "-- Commands"
	@echo " setup -- \t\t Run the initial setup"
	@echo " enableService -- \t\t Enable a service, omit the .yml"
	@echo " listServices -- \t\t List services available and not enabled"
	@echo " htpasswd -- \t\t Generate a htpasswd secret"
	@echo " autheliaSecrets -- \t\t Generate Authelia JWT and Session secrets"
	@echo " listServices -- \t\t List the stacks avalaible"
	@echo " enableService -- \t\t Enable a service and move it to the enabled folder"
	@echo " disableService -- \t\t remove a service from the stack"
	@echo ""
	@echo "-- Docker"
	@echo " stop -- \t\t Stop the containers"
	@echo " start -- \t\t Start the containers"

stop: | 
	/bin/sh $(PWD)/stacksStop.sh

start: | 
	/bin/sh $(PWD)/stacksStart.sh

setup: | autheliaSecrets htpasswd
	@read -p "Input Cloudflare Email: " cloudflareEmail \
	&& /bin/sh -c "echo $${cloudflareEmail} > $(PWD)/secrets/cloudflareEmail"
	@read -p "Input Cloudflare ApiKey: " cloudflareApiKey \
	&& /bin/sh -c "echo $${cloudflareApiKey} > $(PWD)/secrets/cloudflareApiKey"
	@read -p "Input Cloudflare ApiToken: " cloudflareApiToken \
	&& /bin/sh -c "echo $${cloudflareApiToken} > $(PWD)/secrets/cloudflareApiToken"
	@read -p "Input Email Address: " eMail \
	&& /bin/sh -c "echo $${eMail} > $(PWD)/secrets/eMail"
	@read -p "Input Traefik Pilot Token: " traefikPilotToken \
	&& /bin/sh -c "echo $${traefikPilotToken} > $(PWD)/secrets/traefikPilotToken"
	@read -p "Input VPN Username: " openVPNUser \
	&& /bin/sh -c "echo $${openVPNUser} > $(PWD)/secrets/openVPNUserSecret"
	@read -p "Input VPN Password: " openVPNPassword \
	&& /bin/sh -c "echo $${openVPNPassword} > $(PWD)/secrets/openVPNPasswordSecret"
	@read -p "Input Plex Claim Token: " plexClaimToken \
	&& /bin/sh -c "echo $${plexClaimToken} > $(PWD)/secrets/plexClaimToken" \
	@chmod 600 $(PWD)/config/traefik/acme.json

autheliaSecrets:
	@cat /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c128 > secrets/autheliaJwtSecret
	@cat /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c128 > secrets/autheliaSessionSecret
	@echo "Secrets generated"

htpasswd:
	@read -p "Please input username: " username \
	&& /bin/sh -c "htpasswd -c $(PWD)/config/htpasswd $${username}"

listServices:
	@diff -q stacks/available stacks/enabled | grep -v base.yml || echo "All services enabled" && exit 0

enableService:
	@read -p "Please input service name: " serviceName \
	&& /bin/sh -c "ln -s $(PWD)/stacks/available/$${serviceName}.yml stacks/enabled/"

disableService:
	@read -p "Please input service name: " serviceName \
	&& /bin/sh -c "rm $(PWD)/stacks/enabled/$${serviceName}.yml" \
	&& /bin/sh -c "docker-compose -f $(PWD)/stacks/available/$${serviceName}.yml down"