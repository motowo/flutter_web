dc = docker-compose

# Docker Compose
dc_build:
	$(dc) build
dc_up:
	$(dc) up -d
dc_stop:
	$(dc) stop
dc_logs_flutter:
	$(dc) logs -f flutter
dc_logs_firebase:
	$(dc) logs -f firebase
# Flutter
f_build:
# $(dc) exec -it flutter flutter build web
	flutter build web
f_run:
# $(dc) exec -it flutter flutter run -d web-server --web-port=8888 --web-hostname 0.0.0.0
	flutter run -d web-server --web-port=8888 --web-hostname 0.0.0.0
f_clean:
# $(dc) exec -it flutter flutter clean
	flutter clean
f_get:
# $(dc) exec -it flutter flutter pub get
	flutter pub get
f_analyze:
# $(dc) exec -it flutter flutter analyze
	flutter analyze
# Firebase
fb_deploy_pub:
	firebase deploy
fb_deploy_stg:
	firebase hosting:channel:deploy staging
