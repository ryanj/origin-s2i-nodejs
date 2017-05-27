FROM openshift/base-centos7

# This image provides a Node.JS environment you can use to run your Node.JS
# applications.

MAINTAINER RyanJ <ryanj@redhat.com>

EXPOSE 8080

# This image will be initialized with "npm run $NPM_RUN"
# See https://docs.npmjs.com/misc/scripts, and your repo's package.json
# file for possible values of NPM_RUN
ENV NPM_RUN=start \
    NODE_VERSION=7.7.4 \
    NPM_CONFIG_LOGLEVEL=info \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    NPM_VERSION=3 \
    DEBUG_PORT=5858 \
    NODE_ENV=production \
    DEV_MODE=false

LABEL io.k8s.description="Platform for building and running Node.js applications" \
      io.k8s.display-name="Node.js v$NODE_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs$NODE_VERSION" \
      com.redhat.deployments-dir="/opt/app-root/src"

# Download and install a binary from nodejs.org
# Add the gpg keys listed at https://github.com/nodejs/node
RUN set -ex && \
  for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done && \
  INSTALL_PKGS="bzip2 nss_wrapper" && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  curl -o node-v${NODE_VERSION}-linux-x64.tar.gz -sSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
  curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc && \
  gpg --batch -d SHASUMS256.txt.asc | grep " node-v${NODE_VERSION}-linux-x64.tar.gz\$" | sha256sum -c - && \
  tar -zxf node-v${NODE_VERSION}-linux-x64.tar.gz -C /usr/local --strip-components=1 && \
  npm install -g npm@${NPM_VERSION} && \
  find /usr/local/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
  rm -rf ~/node-v${NODE_VERSION}-linux-x64.tar.gz ~/SHASUMS256.txt.asc /tmp/node-v${NODE_VERSION} ~/.npm ~/.node-gyp ~/.gnupg \
    /usr/share/man /tmp/* /usr/local/lib/node_modules/npm/man /usr/local/lib/node_modules/npm/doc /usr/local/lib/node_modules/npm/html

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 /opt/app-root
USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
