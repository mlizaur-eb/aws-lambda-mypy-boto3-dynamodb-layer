#!/usr/bin/env bash
set -e

ROOT_DIR=$(pwd);
OUTPUT_DIR="$ROOT_DIR/build";

LAYER_NAME="mypy_boto3_dynamodb_layer";
LAYER_FILE="$LAYER_NAME.zip";

PY_RUNTIME="python3.8";
PY_SITE_PACKAGES="python/lib/$PY_RUNTIME/site-packages/";

CMD_PIP="pip install -U -r requirements.txt -t $PY_SITE_PACKAGES";
CMD_ZIP="zip -r $LAYER_FILE python";

DOCKER_AWS_IMG="public.ecr.aws/sam/build-$PY_RUNTIME:latest"
DOCKER_WORKING_DIR="/layer"

rm -fr $OUTPUT_DIR $LAYER_FILE \
    && mkdir -p $OUTPUT_DIR \
    && cp requirements.txt "$OUTPUT_DIR" \
    && docker run --rm \
              -v "$OUTPUT_DIR:$DOCKER_WORKING_DIR" \
              -w "$DOCKER_WORKING_DIR" \
              "$DOCKER_AWS_IMG" \
              /bin/bash -c "$CMD_PIP && $CMD_ZIP" \
    && cp $OUTPUT_DIR/$LAYER_FILE $ROOT_DIR \
    && rm -fr $OUTPUT_DIR;
