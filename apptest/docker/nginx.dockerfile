FROM nginx:latest
ENV http_proxy "http://10.131.188.1:80" 
ENV https_proxy "http://10.131.188.1:80"
ENV RAILS_ROOT /var/www/apptest
WORKDIR $RAILS_ROOT
RUN mkdir -p log
COPY ./apptest/public public/
COPY ./apptest/docker/config/nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod 755 -R $RAILS_ROOT
EXPOSE 80 443
ENTRYPOINT ["nginx"]
# Parametros extras para o entrypoint
CMD ["-g", "daemon off;"]