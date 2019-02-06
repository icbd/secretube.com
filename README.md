[![Codacy Badge](https://api.codacy.com/project/badge/Grade/43de7e8c15ca45d798a79cd9afdb1ff8)](https://app.codacy.com/app/icbd/secretube.com?utm_source=github.com&utm_medium=referral&utm_content=icbd/secretube.com&utm_campaign=Badge_Grade_Settings)
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
 