FROM drupal:8.9.7-fpm-buster

ENV VARBASE_VERSION 8.8

WORKDIR /opt/varbase

RUN set -eux; \
        export COMPOSER_HOME="$(mktemp -d)"; \
        export COMPOSER_MEMORY_LIMIT=2G; \
        # Git is required to pull varbase
        apt-get update; \
        apt-get install -y --no-install-recommends git; \
        composer create-project  --no-dev --no-interaction "Vardot/varbase-project:^8.8.7"; \
        chown -R www-data:www-data docroot/sites docroot/modules docroot/themes; \
        ln -sf /opt/varbase/docroot /var/www/html; \
        # delete composer cache
        rm -rf "$COMPOSER_HOME"; \
        # remove build dependencies (git)
        apt-get remove -y git; \
        # delete apt repo lists
        rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["bash"]
