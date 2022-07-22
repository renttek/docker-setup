FROM php:8.1-fpm-alpine

LABEL maintainer="juliann@renttek.de"

RUN set -ex; \
    apk add --no-cache shadow; \
    apk add --no-cache --virtual .build-dependencies \
        autoconf \
        freetype-dev \
        gcc \
        icu-dev \
        imagemagick-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        libzip-dev \
        make \
        musl-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" \
        bcmath \
        gd \
        intl \
        opcache \
        pdo_mysql \
        soap \
        sockets \
        xsl \
        zip; \
    pecl install imagick redis xdebug; \
    docker-php-ext-enable imagick redis xdebug; \
    run_dependencies="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .run-dependencies ${run_dependencies}; \
    apk del .build-dependencies

RUN apk add git openssh binutils patch

RUN set -ex; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY custom-php-entrypoint /usr/local/bin/

RUN chmod +x /usr/local/bin/custom-php-entrypoint

ENTRYPOINT ["/usr/local/bin/custom-php-entrypoint"]

CMD ["php-fpm"]
