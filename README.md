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
bundle exec rake database:reset_tables
```

## Background jobs

```bash
bundle exec sidekiq -r ./sidekiq_requires.rb
```

## Web interface

```bash
bundle exec rackup -o 0.0.0.0
```
