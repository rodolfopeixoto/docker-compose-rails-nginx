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

2 - Criar um **.env** na raiz, onde fica o docker-compose.yml; Você poderá mudar entre environment: production, development e test

```
RAILS_ENV=production
RAILS_SECRET_KEY_BASE=
DEVISE_SECRET_KEY=
```

3 - Mudar o nome das pastas no arquivo docker-compose.yml, [ pasta com o nome da sua aplicação ]/docker/nginx.dockerfile por exemplo:
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

```dockerfile
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

```dockerfile
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

Temos no clone as pastas:
- rails-app-name
  - docker
    - config
      - puma.rb
    - nginx.dockerfile
    - rails.dockerfile
- docker-compose.yml

Documentação
----------------------

Caso, você deseje iniciar um projeto do zero, basta seguir os passos abaixo:

1 - Clone o repositório
2 - Renomee o rails-app-name para o nome que você deseja para a sua aplicação.
3 - Agora vamos construir um container para gerarmos os arquivos. Onde está rails-app-name, você deve trocar para o nome que você renomeou.

```
docker-compose run app1 rails new ./rails-app-name --force --database=postgresql
```

Agora você precisa dar permissão, pois quando você cria algo via comando container, você deve rodar esse comando:

```
sudo chown -R $USER:$USER .
```

Você precisa agora configura o **config/database.yml**


```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  database: app_database
  host: postgresql
  user: <%= ENV['POSTGRES_USER'] %>
  password: <%= ENV['POSTGRES_PASSWORD'] %>

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
```
Modifique também o seu database.yml pelo arquivo acima.

Caso, você queira só em desenvolvimento, basta modificar .env para development e rodar:

```
docker-compose up
```

Caso deseje em production, modifique no .env para production, agora vamos rodar os seguintes comandos:


```
docker-compose run --rm app1 rails secret
```

Adicione o código retornado no arquivo **.env**.


```
docker-compose run --rm app1 rails db:create && rails assets:precompile
```

Agora execute o:

```
docker-compose up

```



### Links diretos

Desenvolvimento
---------------------
-   [Rodolfo Peixoto](http://www.rodolfopeixoto.com.br)
