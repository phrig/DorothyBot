DorothyBot
======
Twitter/Mastodon bot that tweets Dorothy Parker quotes.

### Set-up
This project is designed to run with docker, so be sure to have Docker installed locally. It uses an [Alpine based Docker image](https://github.com/DannyBen/docker-alpine-ruby/tree/ruby3.1.3) and is designed to run as a cloud function on Google Cloud Platform.

Be sure to set up your ENV variables and in a separate file, an example `docker.env` is provided for reference. Each specific service can be enabled/disabled via the `TWITTER_ENABLED` and `MASTODON_ENABLED` variables. 


### Build image
`docker build -t robo-dorothy .`

### Run it
`docker run --env-file docker.env  -p 8080:8080 robo-dorothy`

### Trigger it
`curl -XPOST "http://localhost:8080`
