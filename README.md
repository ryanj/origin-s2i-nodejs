Origin S2I NodeJS
=================

This repository contains sources for an [s2i](https://github.com/openshift/source-to-image) builder image, based on CentOS7 and nodejs releases from nodejs.org.

If you are interested in developing against SCL-based nodejs releases, try [sti-nodejs](https://github.com/openshift/sti-nodejs).

[![docker hub stats](http://dockeri.co/image/ryanj/centos7-s2i-nodejs)](https://hub.docker.com/r/ryanj/centos7-s2i-nodejs/)

[![image layers](https://imagelayers.io/badge/ryanj/centos7-s2i-nodejs.svg)](https://imagelayers.io/?images=ryanj%2Fcentos7-s2i-nodejs:current,ryanj%2Fcentos7-s2i-nodejs:lts,ryanj%2Fcentos7-s2i-nodejs:0.12,ryanj%2Fcentos7-s2i-nodejs:0.10)

For more information about using these images with OpenShift, please see the
official [OpenShift Documentation](https://docs.openshift.org/latest/using_images/s2i_images/nodejs.html).

Versions
---------------
[Node.JS versions currently provided are](https://hub.docker.com/r/ryanj/centos7-s2i-nodejs/tags/):

* `6.3.0` `current`
* `5.12.0`
* `4.4.7` `lts`
* `0.12.15`
* `0.10.46`

Usage
---------------------------------

OpenShift allows you to quickly start a build using the web console, or the CLI.

The [`oc` command-line tool](https://github.com/openshift/origin/releases) can be used to start a build, layering your desired nodejs `REPO_URL` sources into a centos7 image with your selected `RELEASE` of nodejs via the following command format:

    oc new-app ryanj/centos7-s2i-nodejs:RELEASE~REPO_URL

For example, you can run a build (including `npm install` steps), using my [`http-base`](http://github.com/ryanj/http-base) example repo, and the `current` relase of nodejs with:

    oc new-app ryanj/centos7-s2i-nodejs:current~http://github.com/ryanj/http-base

Or, to run the latest `lts` release with my [`pillar-base`](http://github.com/ryanj/pillar-base) example:

    oc new-app ryanj/centos7-s2i-nodejs:lts~http://github.com/ryanj/pillar-base

You can try using any of the available tagged nodejs releases, and your own repo sources - as long as your application source will init correctly with `npm start`, and listen on port 8080.

Builds
------

The [Source2Image cli tools](https://github.com/openshift/source-to-image/releases) are available as a standalone project, allowing you to [run builds outside of OpenShift](https://github.com/ryanj/origin-s2i-nodejs/blob/master/nodejs.org/README.md#usage).

This example will produce a new docker image named `pillarjs`:

    s2i build https://github.com/ryanj/pillar-base ryanj/centos7-s2i-nodejs:current pillarjs

Installation
---------------

There are several ways to make this base image and the full list of tagged nodejs releases available to users during OpenShift's web-based "Add to Project" workflow.

#### For OpenShift Online Next Gen Developer Preview
Those without admin privileges can install the latest nodejs releases within their project context with:

    oc create -f https://raw.githubusercontent.com/ryanj/origin-s2i-nodejs/master/image-streams.json

To ensure that each of the latest NodeJS release tags are available and displayed correctly in the web UI, try upgrading / reinstalling the imageStream:

    oc delete is/centos7-s2i-nodejs ; oc create -f https://raw.githubusercontent.com/ryanj/origin-s2i-nodejs/master/image-streams.json

If you've (automatically) imported this image using the [`oc new-app` example command](#usage), then you may need to clear the auto-imported image stream reference and re-install it.

#### For Administrators

Administrators can make these NodeJS releases available globally (visible in all projects, by all users) by adding them to the `openshift` namespace:

    oc create -n openshift -f https://raw.githubusercontent.com/ryanj/origin-s2i-nodejs/master/image-streams.json

To replace [the default SCL-packaged `openshift/nodejs` image](https://hub.docker.com/r/openshift/nodejs-010-centos7/) (admin access required), run:

    oc delete is/nodejs -n openshift ; oc create -n openshift -f https://raw.githubusercontent.com/ryanj/origin-s2i-nodejs/master/centos7-s2i-nodejs.json

Building your own Builder images
--------------------------------
Clone a copy of this repo to fetch the build sources:

    $ git clone https://github.com/ryanj/origin-s2i-nodejs.git
    $ cd origin-s2i-nodejs

To build your own S2I Node.JS builder images from scratch, run:

    $ docker pull openshift/base-centos7
    $ make build

You can also build a specific release, or try building the alternate `ONBUILD` version of this base:

    $ ONBUILD=true make VERSION=6.3.0

The `ONBUILD` base images are available at https://hub.docker.com/r/ryanj/centos7-nodejs

Test
---------------------
This repository also provides a [S2I](https://github.com/openshift/source-to-image) test framework,
which launches tests to check functionality of a simple Node.JS application built on top of the sti-nodejs image.

Users can choose between testing a Node.JS test application based on a RHEL or CentOS image.

*  **CentOS based image**

    ```
    $ cd sti-nodejs
    $ make test
    ```

Repository organization
------------------------
* **`nodejs.org/`**

    Dockerfile and scripts to build container images.

* **`hack/`**

    Folder containing scripts which are responsible for the build and test actions performed by the `Makefile`.

* ** `image-streams.json` **

    Use this file to add these runtimes to OpenShift's web-based **"Add to Project"** workflow.

* ** `Makefile` **

    See the [build your own builder images](#build_your_own_builder_images) section of the `README` for `build` and `test` usage details.
