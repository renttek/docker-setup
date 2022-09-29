FROM php:8.1-fpm-alpine

LABEL maintainer="juliann@renttek.de"

ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

RUN apk add --no-cache \
    $MUSL_LOCALE_DEPS \
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
      && cd musl-locales-master \
      && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
      && cd .. && rm -r musl-locales-master

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

RUN set -ex; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY custom-php-entrypoint /usr/local/bin/

RUN chmod +x /usr/local/bin/custom-php-entrypoint

ENTRYPOINT ["/usr/local/bin/custom-php-entrypoint"]

CMD ["php-fpm"]
