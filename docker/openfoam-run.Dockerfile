# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Create openfoam '-run' image
#
# docker build -f openfoam-run.Dockerfile .

FROM ubuntu:focal AS distro

# Use wget for fewer dependencies than curl

FROM distro AS runtime
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    apt-utils vim-tiny nano-tiny wget ca-certificates rsync \
    sudo passwd libnss-wrapper \
 && wget -q -O - https://dl.openfoam.com/add-debian-repo.sh | bash \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    openfoam2106 \
 && rm -rf /var/lib/apt/lists/*

# ---------------
# User management
# - nss-wrapper
# - openfoam sandbox directory

FROM runtime AS user
COPY openfoam-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/post-install.sh

ENTRYPOINT [ "/openfoam/run" ]

# ---------------------------------------------------------------------------
