# Official Gerrit Docker Image

The official Gerrit Code Review image with an out-of-the-box setup
with H2 and DEVELOPMENT account setup.

This image is based on CentOS 7 and is intended to be used AS-IS for training
or for staging environments. It can be used for production as base image and
requires customisations to its gerrit.config and definition of persistent external modules.

## Quickstart

Start Gerrit Code Review in its demo/staging out-of-the-box setup:

```
   docker run -d -p 8080:8080 -p 29418:29418 gerritforge/gerrit-centos7
```

Open your browser to http://<docker host url>:8080 and you will be in Gerrit Code Review.

Starting from Ver. 2.14, a new introduction screen guides you through the basics of Gerrit
and allows to install additional plugins automatically downloaded from [Gerrit CI](https://gerrit-ci.gerritforge.com).

## Using external configuration and volumes for production

Extend the image to define a custom gerrit.config and persist Gerrit data across restarts.
See below a simple derived Dockerfile for including a customised gerrit.config and the associated docker-compose.yaml
for persisting the H2 Database, Lucene indexes, Caches and Git repositories.

Example of /docker-compose.yaml
```
  version: '3'

    gerrit:
      build: custom-gerrit
      volumes:
       - git-volume:/var/gerrit/git
       - db-volume:/var/gerrit/db
       - index-volume:/var/gerrit/index
       - cache-volume:/var/gerrit/cache
      ports:
       - "29418:29418"
       - "80:8080"

  volumes:
      local-volume:
      git-volume:
      central-volume:
```

Example of /custom-gerrit/Dockerfile
```
  FROM gerritforge/gerrit-centos7:latest

  RUN git config -f /var/gerrit/etc/gerrit.config httpd.canonicalWebUrl http://localhost/
```
