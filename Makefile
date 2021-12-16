include ./make/wb.dist.Makefile
include ./make/includes/*
include ./make/projects/*
include .env

up: docker_up
down: docker_down
restart: docker_down docker_up

init: _message_initialize _full_init

_message_initialize:
	@echo "\n$(SELECT_COLOR)  $(PROJECT_NAME)  $(STOP_COLOR) $(INFO_COLOR)Initialize... $(STOP_COLOR)\n";

_full_init: docker_down_clear clear_ready docker_pull docker_build docker_up _app_init mark_ready _docker_ps

_app_init: _composer_install _generate_keys _npm_install

_composer_install:
	@echo "\n$(SELECT_COLOR)  $(PROJECT_NAME)  $(STOP_COLOR) $(INFO_COLOR)Installing dependencies...$(STOP_COLOR)\n";
	docker-compose exec $(BACKEND_CONTAINER) composer install --ignore-platform-req=php --no-interaction

_generate_keys:
	@echo "\n$(SELECT_COLOR)  $(PROJECT_NAME)  $(STOP_COLOR) $(INFO_COLOR)Generating keys...$(STOP_COLOR)\n";
	docker-compose exec $(BACKEND_CONTAINER) php bin/console lexik:jwt:generate-keypair

_npm_install:
	@echo "\n$(SELECT_COLOR)  $(PROJECT_NAME)  $(STOP_COLOR) $(INFO_COLOR)Installing assets...$(STOP_COLOR)\n";
	docker-compose exec $(FRONTEND_CONTAINER) npm install

clear_ready:
	@echo "\n$(SELECT_COLOR) $(PROJECT_NAME) $(STOP_COLOR) $(INFO_COLOR)Clearing ready flag...$(STOP_COLOR)\n";
	docker run --rm -v ${PWD}/client:/app --workdir=/app alpine rm -f .ready

mark_ready:
	@echo "\n$(SELECT_COLOR)  $(PROJECT_NAME)  $(STOP_COLOR) $(INFO_COLOR)Setting ready flag...$(STOP_COLOR)\n";
	docker run --rm -v ${PWD}/client:/app --workdir=/app --user=$(shell id -u):$(shell id -g) alpine touch .ready

own:
	sudo chown -R $(shell id -un):$(shell id -gn) .
