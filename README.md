# PostgreSQL ![Build Status Image](https://travis-ci.org/nanobox-io/nanobox-docker-postgresql.svg)

This is an PostgreSQL Docker image used to launch a PostgreSQL service on Nanobox. To use this image, add a data component to your `boxfile.yml` with the `nanobox/postgresql` image specified:

```yaml
data:
  image: nanobox/postgresql
```

## PostgreSQL Configuration Options
PostgreSQL components are configured in your `boxfile.yml`. All available configuration options are outlined below.

### Version
When configuring a PostgreSQL service in your Boxfile, you can specify which version to load into your database service. The following version(s) are available:

- 9.3
- 9.4

**Note:** PostgreSQL versions cannot be changed after the service is created. To use a different version, you'll have to create a new PostgreSQL service.

#### version
```yaml
# default setting
data:
  image: nanobox/postgresql
  config:
    version: 9.4
```

## Request PostgreSQL Boxfile Configs
One of the many benefits of using PostgreSQL is that it doesn't require much configuration. The project itself is finely tuned. However we know there are settings that users may want to tweak. If there's a setting you'd like to modify that is typically handled in the postresql.conf, please let us know by requesting it in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox) (irc.freenode.net #nanobox) or by creating a [new issue on this project](https://github.com/nanobox-io/nanobox-docker-postgresql/issues/new).

## Help & Support
This is a PostgreSQL Docker image provided by [Nanobox](http://nanobox.io). If you need help with this image, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the image, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-docker-postgresql/issues/new).

## License
Mozilla Public License, version 2.0
