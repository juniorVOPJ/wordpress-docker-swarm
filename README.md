# WordPress Optimized Docker Image

Uma imagem Docker WordPress otimizada com suporte completo a PHP, GD, Imagick e configurada para uploads de até 256MB.

## Características

- Baseada na imagem oficial WordPress mais recente
- Suporte completo a processamento de imagens (GD, Imagick)
- Configurada para uploads de arquivos grandes (até 256MB)
- Otimizações de desempenho para PHP e Apache
- Inclui WP-CLI para gerenciamento via linha de comando
- Configurações de segurança aprimoradas

## Como usar

### Docker Run

```bash
docker run -d -p 8080:80 \
  -e WORDPRESS_DB_HOST=db \
  -e WORDPRESS_DB_USER=user \
  -e WORDPRESS_DB_PASSWORD=password \
  -e WORDPRESS_DB_NAME=wordpress \
  seu-usuario/wordpress-optimized:latest
```

### Docker Compose

```yaml
version: '3'
services:
  wordpress:
    image: fusionlabsbrasil/wordpress-full-swarm:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: wordpress
  db:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: user
      MYSQL_PASSWORD: password
      MYSQL_ROOT_PASSWORD: rootpassword
```
### Docker Swarm

```yaml
version: '3.8'
services:
  wordpress:
    image: fusionlabsbrasil/wordpress-full-swarm:latest
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: wordpress
    deploy:
      replicas: 2
```

### Configuração do NGINX como Proxy Reverso
Se estiver usando Nginx como proxy reverso, adicione esta configuração:
```nginx

http {
    client_max_body_size 256M;
    # outras configurações...
}

server {
    # ...
    client_max_body_size 256M;
    # ...
}
```

### Variáveis de ambiente
Todas variáveis da imagem oficial do Wordpress são suportadas.

### Licença
Este projeto está licenciado sob a licença MIT.