[![CircleCI](https://circleci.com/gh/icbd/secretube.com/tree/master.svg?style=svg)](https://circleci.com/gh/icbd/secretube.com/tree/master)

## Deploy

Before deploying, we should install: 
`Ruby 2.6.0` `Nginx` `Lets Encrypted` `Mysql`

```bash
bundle exec cap production puma:nginx_config
bundle exec cap production deploy
```

## TODO

- [ ] Error Collection: rollbar
- [ ] Docker Deamon API
- [ ] Stripe API
 