#!/bin/bash -e

LAST_RELEASE="$(grep 'NODE_VERSION=' nodejs.org/Dockerfile | sed -e "s/ *NODE_VERSION=\([^ ]*\) \\\/\1/")"
LAST_RELEASES="$VERSIONS"
LATEST_RELEASE="$(./hack/latest.js | cut -f5 -d' ')"
LATEST_RELEASES="$(node ./hack/latest.js)"
NUMS="$(seq 1 `echo $LAST_RELEASES | wc -w`)"
#Files with hard-coded version strings:
LAST_UPDATES_NEEDED="centos7-nodejs-onbuild.json \
  centos7-s2i-nodejs.json \
  image-streams-candidate.json \
  image-streams.json \
  README.md"
LATEST_UPDATES_NEEDED="hack/build.sh \
  nodejs.org/Dockerfile \
  nodejs.org/Dockerfile.onbuild"

if [ "${LAST_RELEASES}" != "${LATEST_RELEASES}" ] ; then
  echo "New NodeJS releases available!: ${LATEST_RELEASES}"
  sed -i Makefile -e "s/VERSIONS.*/VERSIONS = $LATEST_RELEASES/"

  for release in $NUMS ; do
    last="$( echo ${LAST_RELEASES} | cut -d' ' -f$release )"
    latest="$( echo ${LATEST_RELEASES} | cut -d' ' -f$release )"
    if [ $last != $latest ] ; then
      echo "Updating v$last to v$latest"
      for file in $LAST_UPDATES_NEEDED ; do
        sed -i $file -e "s/${last}/${latest}/g"
      done
    fi
  done

  if [ "${LAST_RELEASE}" != "${LATEST_RELEASE}" ] ; then
    for file in $LATEST_UPDATES_NEEDED ; do
      sed -i $file -e "s/${LAST_RELEASE}/${LATEST_RELEASE}/g"
    done
  fi

  docker pull openshift/base-centos7

else
  echo "No new NodeJS releases found"
fi
