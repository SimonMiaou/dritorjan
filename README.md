# dritorjan

Collection of utilities for my servers

## Install

```
git clone https://github.com/SimonMiaou/dritorjan.git
cd dritorjan
bundle install
```


## Configuration

Update the configuration files following the examples in `config`

## Database

```bash
# Create tables
bundle exec rake database:create_tables
# Remove tables
bundle exec rake database:drop_tables
# Reset tables
bundle exec rake database:reset
```

## Background jobs

```bash
bundle exec sidekiq -r ./sidekiq_requires.rb
```

## config.json
```json
{
  "directories" : ["/path/to/scan"],
  "root_path" : "/",
  "min_free_space" : 10000000000,
  "auto_remove" : ["basename = 'file_to_remove'"]
}
```
## database.json
```json
{
  "adapter":  "postgresql",
  "host":     "localhost",
  "username": "simon",
  "password": "",
  "database": "dritorjan"
}

```
