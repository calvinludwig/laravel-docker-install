# Laravel Docker install

This is an alternative to Laravel SAIL.

- Start a new project

```bash
docker run --rm -it --volume $(pwd):/var/www/html serversideup/php:8.4-cli bash -c "composer global require laravel/installer && /composer/vendor/bin/laravel new"
```

- Copy `Dockerfile` and `compose.yaml` from this repository to your project

- Start the php container

```bash
docker compose up -d
```
