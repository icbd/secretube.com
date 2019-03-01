[![Codacy Badge](https://api.codacy.com/project/badge/Grade/43de7e8c15ca45d798a79cd9afdb1ff8)](https://app.codacy.com/app/icbd/secretube.org?utm_source=github.com&utm_medium=referral&utm_content=icbd/secretube.org&utm_campaign=Badge_Grade_Settings)
[![CircleCI](https://circleci.com/gh/icbd/secretube.org/tree/master.svg?style=svg)](https://circleci.com/gh/icbd/secretube.org/tree/master)
[![codecov.io](https://codecov.io/github/icbd/secretube.org/coverage.svg?branch=master)](https://codecov.io/github/icbd/secretube.org?branch=master)


## Design

[UML on Google Drive](https://drive.google.com/file/d/1esxKHFGeerLqybnpufnl4eF4g0mYUQTI/view?usp=sharing)


## Deploy

Before deploying, we should install: 
`Ruby 2.6.0` `Nginx` `Lets Encrypted` `Mysql`


You must use Bundler 2 or greater with this lockfile:

```bash
gem update --system
gem install bundler
bundle update --bundler
```


Copy `secret.example.yml` as `secret.yml`. If you use `rails console`, fill out the ENV to `/etc/profile` on the server.

```bash
bundle exec cap production puma:nginx_config
bundle exec cap production deploy
```


## TODO

-  [ ] Error Collection: rollbar
-  [ ] Docker Deamon API
-  [ ] Stripe API

## Test

Default use `SimpleCov::Formatter::Codecov`, will send the report to Codecov.

```bash
rspec
```

Print the report on console.

```bash
SIMPLECOV_FORMATTER="SimpleCov::Formatter::Console" rspec
```

Coverage report generated for RSpec to `./coverage`.

```bash
SIMPLECOV_FORMATTER="SimpleCov::Formatter::HTMLFormatter" rspec
```
