[![CircleCI](https://circleci.com/gh/icbd/secretube.com/tree/master.svg?style=svg)](https://circleci.com/gh/icbd/secretube.com/tree/master)

# 部署

```
bundle exec cap production puma:nginx_config
bundle exec cap production deploy
```

# TODO LIST

- 异常收集: rollbar
- 测试覆盖: simplecov
- 代码规范: rubocop