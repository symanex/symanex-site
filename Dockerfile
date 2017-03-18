FROM httpd:2.4
RUN mkdir -p /usr/local/apache2/htdocs/symanex-site
COPY . /usr/local/apache2/htdocs/symanex-site/
