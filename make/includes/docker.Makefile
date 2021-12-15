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

docker_logs:
	@-title "📔 Logs"
	-docker-compose logs -f

_docker_ps:
	@echo "\n$(INFO_COLOR)Containers...$(STOP_COLOR)\n";
	docker-compose ps
	@echo "\n";
