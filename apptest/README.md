## RAILS COM GITLAB-CI FOR TSURU

Para utilizar o gitlab-ci com os stages: test, staging e deploy, você precisará de algumas gems instaladas e configuradas.

Requisito:
  - Rubocop
  - Simplecov
  - Rails best practices
  - brakeman
  - RSpec

Para configurar o rubocop:

```
rubocop --auto-gen-config
```

```
rubocop --auto-correct
```

Para configurar o simplecov:

No rails_helper.rb adicione o código abaixo

```ruby
require 'simplecov'
SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::Console
```