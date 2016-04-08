NodeJS Docker image
===================

This repository contains the source for building various versions of
the Node.JS application as a reproducible Docker image using
[source-to-image](https://github.com/openshift/source-to-image).

CentOS based builder images with Nodejs binaries from nodejs.org.
The resulting image can be run using [Docker](http://docker.io).

If you are interested in using SCL-based nodejs binaries, try [sti-nodejs](https://github.com/openshift/sti-nodejs)

Usage
---------------------
To build a simple [nodejs example app](https://github.com/ryanj/pillar-base) application using standalone [STI](https://github.com/openshift/source-to-image):

```
$ s2i build https://github.com/ryanj/pillar-base ryanj/centos7-s2i-nodejs:stable pillarjs
```

Run the resulting image with [Docker](http://docker.io):

```
$ docker run -p 8080:8080 pillarjs
```

Access the application:
```
$ curl 127.0.0.1:8080
```

Repository organization
------------------------
* **`nodejs.org`**

    * **Dockerfile**

        CentOS based Dockerfile with 64bit nodejs binaries from nodejs.org.

    * **Dockerfile.sourcebuild**

        CentOS based Dockerfile, nodejs binaries built from source (downloaded from nodejs.org).

    * **`s2i/bin/`**

        This folder contains scripts that are run by [STI](https://github.com/openshift/source-to-image):

        *   **assemble**

            Used to install the sources into the location where the application
            will be run and prepare the application for deployment (eg. installing
            modules using npm, etc.)

        *   **run**

            This script is responsible for running the application, by using the
            application web server.

        *   **usage***

            This script prints the usage of this image.

    * **`contrib/`**

        This folder contains a file with commonly used modules.

    * **`test/`**

        This folder contains the [S2I](https://github.com/openshift/source-to-image)
        test framework with simple Node.JS echo server.

        * **`test-app/`**

            A simple Node.JS echo server used for testing purposes by the [S2I](https://github.com/openshift/source-to-image) test framework.

        * **run**

            This script runs the [S2I](https://github.com/openshift/source-to-image) test framework.


Environment variables
---------------------

To set environment variables, you can place them as a key value pair into a `.sti/environment`
file inside your source code repository.

Example: DATABASE_USER=sampleUser

Setting the HTTP_PROXY or HTTPS_PROXY environment variable will set the appropriate npm proxy configuration during assembly.

Development Mode
---------------------
This image supports development mode. This mode can be switched on and off with the environment variable `DEV_MODE`. `DEV_MODE` can either be set to `true` or `false`.
Development mode supports two features:
* Hot Deploy
* Debugging

The debug port can be speicifed with the environment variable `DEBUG_PORT`. `DEBUG_PORT` is only valid if `DEV_MODE=true`.

A simple example command for running the docker container in production mode is:
```
docker run --env DEV_MODE=true my-image-id
```

To run the container in development mode with a debug port of 5454, run:
```
$ docker run --env DEV_MODE=true DEBUG_PORT=5454 my-image-id
```

To run the container in production mode, run:
```
$ docker run --env DEV_MODE=false my-image-id
```

By default, `DEV_MODE` is set to `false`, and `DEBUG_PORT` is set to `5858`, however the `DEBUG_PORT` is only relevant if `DEV_MODE=true`.

Hot deploy
--------------------

As part of development mode, this image supports hot deploy. If development mode is enabled, any souce code that is changed in the running container will be immediately reflected in the running nodejs application.

### Using Docker's exec

To change your source code in a running container, use Docker's [exec](http://docker.io) command:
```
$ docker exec -it <CONTAINER_ID> /bin/bash
```

After you [Docker exec](http://docker.io) into the running container, your current directory is set to `/opt/app-root/src`, where the source code for your application is located.

### Using OpenShift's rsync

If you have deployed the container to OpenShift, you can use [oc rsync](https://docs.openshift.org/latest/dev_guide/copy_files_to_container.html) to copy local files to a remote container running in an OpenShift pod.

#### Warning:

The default behaviour of the sti-nodejs docker image is to run the Node.js application using the command `npm start`. This runs the _start_ script in the _package.json_ file. In developer mode, the application is run using the command `nodemon`. The default behaviour of nodemon is to look for the _main_ attribute in the _package.json_ file, and execute that script. If the _main_ attribute doesn't appear in the _package.json_ file, it executes the _start_ script. So, in order to achieve some sort of uniform functionality between production and development modes, the user should remove the _main_ attribute.

Below is an example _package.json_ file with the _main_ attribute and _start_ script marked appropriately:

```json
{
    "name": "node-echo",
    "version": "0.0.1",
    "description": "node-echo",
    "main": "example.js", <--- main attribute
    "dependencies": {
    },
    "devDependencies": {
        "nodemon": "*"
    },
    "engine": {
        "node": "*",
        "npm": "*"
    },
    "scripts": {
        "dev": "nodemon --ignore node_modules/ server.js",
        "start": "node server.js" <-- start script
    },
    "keywords": [
        "Echo"
    ],
    "license": "",
}
```

#### Note:
`oc rsync` is only available in versions 3.1+ of OpenShift.
