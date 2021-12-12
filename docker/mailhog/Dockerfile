FROM alpine:latest

LABEL maintainer="juliann@renttek.de"

ENV MAILHOG_VERSION=v1.0.1

RUN apk --no-cache add ca-certificates; \
    mkdir /app; \
    adduser --home=/app --no-create-home --disabled-password mailhog mailhog; \
    chown mailhog:mailhog /app

ADD https://github.com/mailhog/MailHog/releases/download/${MAILHOG_VERSION}/MailHog_linux_amd64 /app/mailhog
RUN chmod +x /app/mailhog

WORKDIR /app/
CMD ["./mailhog"]

EXPOSE 1025
EXPOSE 8025
