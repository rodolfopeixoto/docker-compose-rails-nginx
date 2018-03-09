# DOCKER RAILS NGINX  AND POSTGRESQL CONTAINERIZED

Hoje vivemos o mundo dos containers, desenvolvi esses files para que possa rapidamente levantar um ambiente tanto de desenvolvimento,
quanto de produção para utilização imediata. O app utiliza **nginx**, **postgresql** e o app rails, onde o nginx já está utilizando o loand balance para que você tenha requisiçes
para apps diferentes, por exemplo:

Rodolfo acessou: requisita o container app1 (como você pode verificar no docker-compose.yml).

Thaís acessou: requisita o container app2.

Léo acessou: requisita o container app3.

Carlos acessou: requisita o container app1.

e assim, segue o fluxo, onde você distribui a quantidade de requisição para diversos apps rails.

Versão do Projeto 0.01
======================

ATENÇÃO

---------------------
Caso você queira containerizar um app rails já existente, você deve seguir os passos abaixo:

1 - Copiar da pasta rails-app-name a pasta docker e copiar o config/puma.rb para o seu arquivo existente. Lembre-se de substituir o já existe.

2 - Mudar o nome das pastas no arquivo docker-compose.yml, [ pasta com o nome da sua aplicação ]/docker/nginx.dockerfile por exemplo:
o nome da pasta do meu app é railsapp-name, então vou modificar de sispict para railsapp-name.

```dockerfile
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
```

PARA

```dockerfile
 FROM nginx:latest
ENV RAILS_ROOT /var/www/railsapp-name
WORKDIR $RAILS_ROOT
RUN mkdir -p log
COPY ./railsapp-name/public public/
COPY ./railsapp-name/docker/config/nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod 755 -R $RAILS_ROOT
EXPOSE 80 443
ENTRYPOINT ["nginx"]
# Parametros extras para o entrypoint
CMD ["-g", "daemon off;"]
```

Mesma coisa no documento docker/rails.dockerfile de:

```
FROM ruby:2.4-jessie

ENV SECRET_KEY_BASE text
ENV SISPICT_DATABASE_PASSWORD production
ENV RAILS_ROOT /sispict
ENV RAILS_ENV production 
ENV RACK_ENV production


RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs aptitude

RUN aptitude install -y graphviz
RUN rm -rf /var/lib/apt/lists/*

# App specific installations are run separatelly so previous is a rehused container
RUN apt-get install -y imagemagick && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY $RAILS_ROOT/Gemfile $RAILS_ROOT/Gemfile
COPY $RAILS_ROOT/Gemfile.lock $RAILS_ROOT/Gemfile.lock
RUN bundle install
COPY $RAILS_ROOT $RAILS_ROOT
EXPOSE 3000
CMD ["bundle","exec", "puma", "-C", "config/puma.rb"]

```

PARA

```
FROM ruby:2.4-jessie

ENV SECRET_KEY_BASE text
ENV SISPICT_DATABASE_PASSWORD production
ENV RAILS_ROOT /railsapp-name
ENV RAILS_ENV production 
ENV RACK_ENV production


RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs aptitude

RUN aptitude install -y graphviz
RUN rm -rf /var/lib/apt/lists/*

# App specific installations are run separatelly so previous is a rehused container
RUN apt-get install -y imagemagick && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY $RAILS_ROOT/Gemfile $RAILS_ROOT/Gemfile
COPY $RAILS_ROOT/Gemfile.lock $RAILS_ROOT/Gemfile.lock
RUN bundle install
COPY $RAILS_ROOT $RAILS_ROOT
EXPOSE 3000
CMD ["bundle","exec", "puma", "-C", "config/puma.rb"]

```

No **docker-compose.yml** também, onde você achar sispict, você modificar para rails-app-name.
Após, esse passo, basta rodar:

```
docker-compose build
```
E depois:

```
docker-compose up
```

Caso dê problema de **bad gateway 502**, você deve verificar se você copiou o docker/config/puma.rb para o seu puma.rb.


Configuração inicial

---------------------

Clone o repositório e acesse a pasta do projeto, no terminal:

Documentação
----------------------

```

### Links diretos

Desenvolvimento
---------------------
-   [Rodolfo Peixoto](http://www.rodolfopeixoto.com.br)
