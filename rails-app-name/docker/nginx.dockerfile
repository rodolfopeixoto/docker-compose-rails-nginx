FROM nginx:latest
ENV RAILS_ROOT /var/www/sispict
WORKDIR $RAILS_ROOT
RUN mkdir -p log
COPY ./sispict/public public/
COPY ./sispict/docker/config/nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod 755 -R $RAILS_ROOT
EXPOSE 80 443
ENTRYPOINT ["nginx"]
# Parametros extras para o entrypoint
CMD ["-g", "daemon off;"]