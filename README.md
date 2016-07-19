DockerFile for Medlib (https://www.medlib.fr/)

This image is based on `php:7` official version.

The easiest way to try this image is via docker compose :

```
db:
  image: mysql
  environment:
    MYSQL_DATABASE: medlib-dev
    MYSQL_ROOT_PASSWORD: root

app:
  image: medlib/nginx
  links:
    - db:mysql

web:
  image: nginx
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf:ro
  links:
    - medlib
  volumes_from:
    - medlib
  ports:
    - 80
```

To make your data persistant, you have to mount `/var/www/app/public/avatars` and `/var/www/app/storage`.
