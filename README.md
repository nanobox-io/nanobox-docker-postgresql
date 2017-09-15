# PostgreSQL [![Build Status Image](https://travis-ci.org/nanobox-io/nanobox-docker-postgresql.svg)](https://travis-ci.org/nanobox-io/nanobox-docker-postgresql)

This is an PostgreSQL Docker image used to launch a PostgreSQL service on Nanobox. To use this image, add a data component to your `boxfile.yml` with the `nanobox/postgresql` image specified:

```yaml
data.db:
  image: nanobox/postgresql
```

## PostgreSQL Configuration Options
PostgreSQL components are configured in your `boxfile.yml`. All available configuration options are outlined below.

### Version
When configuring a PostgreSQL service in your boxfile.yml, you can specify which version to load into your database service. The following version(s) are available:

- 9.3
- 9.4
- 9.5
- 9.6

**Note:** PostgreSQL versions cannot be changed after the service is created. To use a different version, you'll have to create a new PostgreSQL service.

#### version
```yaml
# default setting
data.db:
  image: nanobox/postgresql
  config:
    version: 9.4
```

### Custom Users/Permissions/Databases
You can create custom users with custom permissions as well as additional databases.

```yaml
data.postgresql:
  image: nanobox/postgresql:9.5
  config:
    users:
    - username: customuser
      meta:
        privileges:
        - privilege: ALL PRIVILEGES
          type: DATABASE
          'on': gonano
          grant: true
        - privilege: ALL PRIVILEGES
          type: DATABASE
          'on': customdb
          grant: true
        roles:
        - SUPERUSER
```

For each custom user specified, Nanobox will generate an environment variable for the user's password using the following pattern:

```yaml
# Pattern
COMPONENT_ID_USERNAME_PASS

# Examples

## Custom user config 1
data.postgres:
  config:
    users:
      - username: customuser

## Generated password evar 1
DATA_POSTGRES_CUSTOMUSER_PASS

## Custom user config 2
data.db:
  config:
    users:
      - username: dbuser

## Generated password evar 2
DATA_DB_DBUSER_PASS
```

## Request PostgreSQL Boxfile Configs
One of the many benefits of using PostgreSQL is that it doesn't require much configuration. The project itself is finely tuned. However we know there are settings that users may want to tweak. If there's a setting you'd like to modify that is typically handled in the postresql.conf, please let us know by creating a [new issue on this project](https://github.com/nanobox-io/nanobox-docker-postgresql/issues/new).

## Help & Support
This is a PostgreSQL Docker image provided by [Nanobox](http://nanobox.io). If you need help with this image, you can reach out to us in the [Nanobox Slack channel](http://nanoboxio.slack.com). If you are running into an issue with the image, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-docker-postgresql/issues/new).

## License
Mozilla Public License, version 2.0
