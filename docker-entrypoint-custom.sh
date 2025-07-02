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
    
    # Limpar cache e otimizar banco de dados
    wp cache flush --allow-root
    wp db optimize --allow-root
  fi
}

# Executar as configurações extras em segundo plano para não atrasar a inicialização
setup_wordpress_extras &

# Executar o comando original
exec "$@"