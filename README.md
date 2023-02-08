DorothyBot
======

Twitter/Mastodon bot that tweets Dorothy Parker quotes.

### Set-up
This project is designed to run with docker, so be sure to have Docker installed locally. It uses a AWS provided Docker image as a starting point so it can easily run on AWS lambda.

Be sure to set up your ENV variables and in a separate file, an example `docker.env` is provided for reference. Each specific service can be enabled/disabled via the `TWITTER_ENABLED` and `MASTODON_ENABLED` variables. 


### Build image
`docker build -t robo-dorothy .`

### Run it
`docker run --env-file docker.env  -p 9000:8080 robo-dorothy`

### Trigger it
`curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'`
