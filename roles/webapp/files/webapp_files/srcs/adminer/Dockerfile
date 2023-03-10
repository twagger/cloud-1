# syntax=docker/dockerfile:1
FROM    alpine:3.15

# labels
LABEL   org.opencontainers.image.authors=twagner
LABEL   org.opencontainers.image.source=https://github.com/twagger/inception
LABEL   org.opencontainers.image.version=0.1.0

# args for proper user rights management
ARG     USER_ID=${USER_ID}
ARG     GROUP_ID=${GROUP_ID}

# workdir
WORKDIR /var/www/adminer

# add specific user and group with current host userid and groupid to run the process
RUN     addgroup -S -g ${GROUP_ID} adminer \
 &&     adduser -S -G adminer -u ${USER_ID} adminer \
\
# install PHP from package manager to run adminer 
 &&     apk update && apk upgrade && apk add --update --no-cache \
            php8 \
            php8-fpm \
            php8-opcache \
            php8-mysqli \
            php8-phar \
            php8-iconv \
            php8-session \
            mysql-client \
 &&     rm -f /var/cache/apk/* \
\
# bin link
 &&     ln -s /usr/bin/php8 /usr/bin/php \
\
# get adminer on a specific folder
 &&     wget -O index.php "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" \
 &&     chown -R adminer:adminer /var/www/adminer

# configure PHP
COPY    conf/php-fpm.conf   /etc/php8/
COPY    conf/www.conf       /etc/php8/php-fpm.d/

EXPOSE  9042

# launch command as non root
USER    adminer

CMD     ["php-fpm8"]
