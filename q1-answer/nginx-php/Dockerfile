FROM webdevops/php-nginx:latest

RUN apt-get update
RUN apt-get install -y php-pgsql

COPY index.php ${WEB_DOCUMENT_ROOT}
