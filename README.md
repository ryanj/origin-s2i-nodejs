Origin S2I NodeJS
=================

This repository contains the source for building various versions of
the Node.JS application as a reproducible Docker image using
[source-to-image](https://github.com/openshift/source-to-image).
Users can choose between RHEL and CentOS based builder images.
The resulting image can be run using [Docker](http://docker.io).

For more information about using these images with OpenShift, please see the
official [OpenShift Documentation](https://docs.openshift.org/latest/using_images/s2i_images/nodejs.html).

Versions
---------------
[Node.JS versions currently provided are](https://hub.docker.com/r/ryanj/centos7-s2i-nodejs/tags/):

* `0.10.44` `0.10`
* `0.12.13` `0.12`
* `4.4.2` `4.4` `4` `lts`
* `5.10.1` `5.10` `5` `stable` `latest`

Installation
---------------

To install these nodejs S2I builders into your current project, making them available in the web-based OpenShift "create" workflow, run:

    oc create -f https://raw.githubusercontent.com/ryanj/origin-s2i-nodejs/master/image-streams.json

Administrators can make these builders available globally (visible in all projects) by adding them to the `openshift` namespace:

    oc create -n openshift -f https://raw.githubusercontent.com/ryanj/origin-s2i-nodejs/master/image-streams.json

Building your own Builder images
--------------------------------
To build a Node.JS image:
*  **CentOS based image**

    This image is available on DockerHub. To download it run:

    ```
    $ docker pull ryanj/centos7-s2i-nodejs
    ```

    To build a Node.JS image from scratch run:

    ```
    $ git clone https://github.com/ryanj/origin-s2i-nodejs.git
    $ cd origin-s2i-nodejs
    $ make build VERSION=5.10.1
    ```

Usage
---------------------------------

For information about usage of Dockerfile for NodeJS,
see [usage documentation](nodejs.org/README.md).


Test
---------------------
This repository also provides a [S2I](https://github.com/openshift/source-to-image) test framework,
which launches tests to check functionality of a simple Node.JS application built on top of the sti-nodejs image.

Users can choose between testing a Node.JS test application based on a RHEL or CentOS image.

*  **CentOS based image**

    ```
    $ cd sti-nodejs
    $ make test VERSION=5.10.1
    ```

Repository organization
------------------------
* **`nodejs.org/`**

    Dockerfile and scripts to build container images.

* **`hack/`**

    Folder containing scripts which are responsible for the build and test actions performed by the `Makefile`.

