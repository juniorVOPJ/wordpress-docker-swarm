#!/bin/bash
set -euo pipefail

# Executar o script original de entrada do WordPress
source /usr/local/bin/docker-entrypoint.sh

# Configurações adicionais após a inicialização do WordPress
setup_wordpress_extras() {
  # Verificar se o WordPress está instalado
  if wp core is-installed --allow-root; then
    echo "WordPress já está instalado, aplicando otimizações..."
    
    # Otimizações adicionais podem ser adicionadas aqui
    wp option update uploads_use_yearmonth_folders 1 --allow-root
    
    # Instalar e ativar plugin Redis Object Cache se não estiver presente
    if ! wp plugin is-installed redis-cache --allow-root; then
      echo "Instalando plugin Redis Object Cache..."
      wp plugin install redis-cache --activate --allow-root
    elif ! wp plugin is-active redis-cache --allow-root; then
      echo "Ativando plugin Redis Object Cache..."
      wp plugin activate redis-cache --allow-root
    fi
    
    # Ativar o Redis Object Cache
    if wp plugin is-active redis-cache --allow-root; then
      echo "Ativando Redis Object Cache..."
      wp redis enable --allow-root
    fi
    
    # Limpar cache e otimizar banco de dados
    wp cache flush --allow-root
    wp db optimize --allow-root
  fi
}

# Executar as configurações extras em segundo plano para não atrasar a inicialização
setup_wordpress_extras &

# Executar o comando original
exec "$@"