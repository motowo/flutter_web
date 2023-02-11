dc = docker-compose

#
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
flutter_run:
	$(dc) exec -it flutter flutter run -d web-server --web-port=8888 --web-hostname 0.0.0.0
flutter_clean:
	$(dc) exec -it flutter flutter clean
flutter_pub_get:
	$(dc) exec -it flutter flutter pub get
flutter_analyze:
	$(dc) exec -it flutter flutter analyze
