# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Create openfoam '-run' image using Ubuntu.
#
# Example
#     docker build -f openfoam-run.Dockerfile .
#     docker build --build-arg OS_VER=impish --build-arg FOAM_VERSION=2112
#         -t opencfd/openfoam2112-run ...
#
# Note
#    Uses wget for fewer dependencies than curl
#
# ---------------------------------------------------------------------------
ARG OS_VER=latest

FROM ubuntu:${OS_VER} AS distro

FROM distro AS runtime
ARG FOAM_VERSION=2112
ARG PACKAGE=openfoam${FOAM_VERSION}
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    apt-utils vim-tiny nano-tiny wget ca-certificates rsync \
    sudo passwd libnss-wrapper \
 && wget -q -O - https://dl.openfoam.com/add-debian-repo.sh | bash \
 && apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*

# ---------------
# User management
# - nss-wrapper
# - openfoam sandbox directory

FROM runtime AS user
COPY openfoam-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/post-install.sh -fix-perms

ENTRYPOINT [ "/openfoam/run" ]

# ---------------------------------------------------------------------------
