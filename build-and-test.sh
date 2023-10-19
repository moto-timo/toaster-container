#!/bin/bash
# Copyright (C) 2016 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
#
set -e

#GITREPO="git://git.yoctoproject.org/poky-contrib"
#BRANCH="timo/hardknott/toaster-fixes"
GITREPO="git://git.yoctoproject.org/poky"
BRANCH="master"

# Allow the user to specify another command to use for building such as podman.
if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

if [ "${GITREPO}" = "" ]; then
    GITREPO="git://git.yoctoproject.org/poky"
fi

if [ "${BRANCH}" = "" ]; then
    BRANCH="master"
fi

if [ "${REPO}" = "" ]; then
    REPO="crops/toaster-${BRANCH}"
fi

${ENGINE_CMD} build --build-arg GITREPO=${GITREPO} --build-arg BRANCH=${BRANCH} --pull -t ${REPO} .

if command -v annotate-output; then
    ANNOTATE_OUTPUT=annotate-output
fi

if [ "${SELENIUM_TIMEOUT}" = "" ]; then
    SELENIUM_TIMEOUT=600
fi

if [ "${IMAGE}" = "" ]; then
    IMAGE="${REPO}:latest"
fi

$ANNOTATE_OUTPUT bash -c "cd tests; SELENIUM_TIMEOUT=${SELENIUM_TIMEOUT} IMAGE=${IMAGE} SHOW_LOGS_ON_FAILURE=1 ./runtests.sh"
