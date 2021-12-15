include ./make/wb.dist.Makefile
include ./make/includes/*
include ./make/projects/*
include .env

up: docker_up
down: docker_down
restart: docker_down docker_up

init: _message_initialize _full_init

_message_initialize:
	@echo "$(INFO_COLOR)";
	@echo "Initialize...";
	@echo "$(STOP_COLOR)";

_full_init: docker_down_clear clear_ready docker_pull docker_build docker_up _app_init mark_ready _docker_ps

docker_down:
	@echo "\n$(WARNING_COLOR)Stopping containers...$(STOP_COLOR)\n";
	docker-compose down --remove-orphans

docker_down_clear:
	@echo "\n$(WARNING_COLOR)Stopping containers...$(STOP_COLOR)\n";
	docker-compose down -v --remove-orphans

docker_pull:
	@echo "\n$(INFO_COLOR)Pulling images...$(STOP_COLOR)\n";
	@docker-compose pull

docker_build:
	@echo "\n$(INFO_COLOR)Building containers...$(STOP_COLOR)\n";
	docker-compose build

docker_up:
	@-title
	@echo "\n$(INFO_COLOR)Starting containers...$(STOP_COLOR)\n";
	docker-compose up -d

_docker_ps:
	@echo "\n$(INFO_COLOR)Containers...$(STOP_COLOR)\n";
	docker-compose ps
	@echo "\n";

_app_init: _composer_install _npm_install

_composer_install:
	@echo "\n$(SELECT_COLOR)  $(PROJECT_NAME)  $(STOP_COLOR) $(INFO_COLOR)Installing dependencies...$(STOP_COLOR)\n";
	docker-compose exec $(BACKEND_CONTAINER) composer install --ignore-platform-req=php --no-interaction

_npm_install:
	@echo "\n$(SELECT_COLOR)  $(PROJECT_NAME)  $(STOP_COLOR) $(INFO_COLOR)Installing assets...$(STOP_COLOR)\n";
	docker-compose exec $(FRONTEND_CONTAINER) npm install

clear_ready:
	@echo "\n$(SELECT_COLOR) $(PROJECT_NAME) $(STOP_COLOR) $(INFO_COLOR)Clearing ready flag...$(STOP_COLOR)\n";
	docker run --rm -v ${PWD}/client:/app --workdir=/app alpine rm -f .ready

mark_ready:
	@echo "\n$(SELECT_COLOR)  $(SEINE)  $(STOP_COLOR) $(INFO_COLOR)Setting ready flag...$(STOP_COLOR)\n";
	docker run --rm -v ${PWD}/client:/app --workdir=/app --user=$(shell id -u):$(shell id -g) alpine touch .ready

own:
	sudo chown -R $(shell id -un):$(shell id -gn) .

docker_logs:
	@-title "📔 Logs"
	-docker-compose logs -f
