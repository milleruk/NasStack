# NASStack

# Authelia setup
1. Generate a hash of your password: `docker run authelia/authelia:latest authelia hash-password <your password>` it will return something like:
```
docker run authelia/authelia:latest authelia hash-password asdf
Unable to find image 'authelia/authelia:latest' locally
latest: Pulling from authelia/authelia
540db60ca938: Pull complete
5e0bcc8db347: Pull complete
1260aac8b5d5: Pull complete
4bdf19af693a: Pull complete
3aea23195115: Pull complete
Digest: sha256:ca5048097b257d0047e7f5a42557f0375827803db480533b3611228d2a15cc72
Status: Downloaded newer image for authelia/authelia:latest
Password hash: $argon2id$v=19$m=65536,t=1,p=8$b3h1YUZpdEZqTEpJdEJybQ$d0XKr6LgolQxEN073S/x7iRXZUKMtoIHI6GoBj9Y3JI
```
2. Copy `data/authelia/configuration.sample.yml` to `data/authelia/configuration.yml` and copy `data/authelia/users_database.sample.yml` to `data/authelia/users_database.yml`
3. Edit `data/authelia/configuration.yml` and replace `yourdomain.com` with your domain
4. Edit `data/authelia/users_database.yml` and insert your password hash generated initially into the password field (and edit the rest accordingly)
5. First time you start Authelia, tail the `data/authelia/notification.txt` file, since it generates a URL you need to click to validate

# Sample files
There are sample files located at:
- `/config/traefik/rules/middlewares.sample.yml`
- `/data/authelia/configuration.sample.yml`
- `/data/authelia/users_database.sample.yml`

All of these needs to be copied to the same folder, with the same name minus `.sample` - after that edit them and replace domain, email, username etc.
