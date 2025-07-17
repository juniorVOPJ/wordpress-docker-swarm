# Use a imagem oficial mais recente do WordPress como base
FROM wordpress:latest

LABEL maintainer="Vilmo Júnior <junior.vopj@acidburn.com.br>"
LABEL description="WordPress otimizado com suporte completo a PHP, GD, Redis e uploads de até 256MB, pronto para Docker Swarm e Portainer"

# Instalar dependências e extensões PHP adicionais
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    libxml2-dev \
    libxslt1-dev \
    libmagickwand-dev \
    imagemagick \
    ghostscript \
    unzip \
    git \
    mariadb-client \
    libzstd-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Configurar e instalar extensões PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    opcache \
    exif \
    zip \
    intl \
    xsl \
    soap \
    bcmath \
    calendar \
    sockets

# Instalar e habilitar imagick se disponível
RUN pecl install imagick && docker-php-ext-enable imagick || echo "Imagick não disponível"

# Instalar e habilitar Redis
RUN pecl install redis && docker-php-ext-enable redis

# Instalar WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copiar configurações personalizadas
COPY php-custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY apache-custom.conf /etc/apache2/conf-available/custom.conf

# Habilitar configurações do Apache
RUN a2enconf custom \
    && a2enmod rewrite headers expires remoteip

# Script de entrada personalizado
COPY docker-entrypoint-custom.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint-custom.sh

# Verificar configurações
RUN php -i | grep -E 'upload_max_filesize|post_max_size|memory_limit|GD|imagick|redis'

# Usar o script de entrada personalizado
ENTRYPOINT ["docker-entrypoint-custom.sh"]
CMD ["apache2-foreground"]