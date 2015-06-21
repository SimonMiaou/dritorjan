# dritorjan
Help to managing files on one of my servers

```
git clone https://github.com/SimonMiaou/dritorjan.git
cd dritorjan
bundle install
```

## config.json
```json
{
  "directories" : ["/path/to/scan"],
  "root_path" : "/",
  "min_free_space" : 10000000000
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
