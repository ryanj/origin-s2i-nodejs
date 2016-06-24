#!/bin/bash -e

BASE_IMAGES="${NAMESPACE}/${OS}-${ONBUILD_IMAGE_NAME} ${NAMESPACE}/${OS}-${BASE_IMAGE_NAME} ${NAMESPACE}/${OS}-${BASE_IMAGE_NAME}-candidate"

for BASE in $BASE_IMAGES ; do
  echo "publishing: ${BASE}..."
  docker push $BASE
done
