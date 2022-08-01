# aws-localstack-example

A simple setup to deploy LocalStack + Portainer with custom templates.

[http://localhost:4566/health](http://localhost:4566/health) to get health status of local AWS services.
# Usage

The default configuration will connect Portainer against the local Docker host, using an nginx container (port 80).

Simply run this command from project root directory:

```
$ docker-compose up -d
```

And then access Portainer by hitting [http://localhost:9000](http://localhost:9000) with a web browser.

