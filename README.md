# Checker

## Summary

Provides API for making TCP pings via ["net/ping"](https://github.com/djberg96/net-ping).

## Installing

[rvm + passenger + nginx](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_language_runtime.html/).

## Usage

Setup `.env`

```
CHECKER_TOKEN=TOKEN
```

and you will able to make GET requests:

```
https://checker.my.domain/api/v1/check/?ip=192.0.2.1&port=80&token=TOKEN
```

or

```
https://checker.my.domain/?ip=192.0.2.1&port=80&token=TOKEN
```

## License

Checker is distributed under the WTFPL.
