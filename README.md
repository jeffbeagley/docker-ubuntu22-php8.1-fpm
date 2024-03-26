# Containerized Ubuntu 22 with Apache2+PHP8.1-fpm

Reorganized setup for containerizing Apache and PHP-FPM. Aligns file/folder structure to that of the linux filesystem, and
sets up a web directory that is agnostic to platform or cms. 

The apt install process was inspired by that of pip (python package manager) in how it can store dependencies within a
requirements.txt file for easy management. Here we have a packages.txt that outlines packages that get installed 
via apt.

## Logging

Apache and PHP error logs will get shipped to stdout/stderr

## Entrypoints

There are 2 files for starting the application, and are under scripts/

- start.sh

	This file is the default entrypoint for the container, will run the entrypoint.sh file then start PHP and Apache

- entrypoint.sh

	This file is separate from start.sh in the event you need to run php-cli commands via something like cron and have no need
to start apache


## Getting Started

These instructions will cover usage information

### Prerequisities

In order to run this container you'll need docker installed.

- [Windows](https://docs.docker.com/windows/started)
- [OS X](https://docs.docker.com/mac/started/)
- [Linux](https://docs.docker.com/linux/started/)

### Usage

Build

```shell
docker build . -t <some_tag>
```

Run

```shell
docker run -it -p 80:80 <some_tag>
```

