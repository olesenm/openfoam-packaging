# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Create openfoam '-run' image for Fedora using copr repo.
#
# Example
#     docker build -f openfoam-run_fedora.Dockerfile .
#     docker build --build-arg OS_VER=35 --build-arg FOAM_VERSION=2112 ...
#
# ---------------------------------------------------------------------------
ARG OS_VER=latest

FROM fedora:${OS_VER} AS distro

FROM distro AS runtime
ARG FOAM_VERSION=2106
ARG PACKAGE=openfoam${FOAM_VERSION}

RUN dnf -y install rsync wget bzip2 xz unzip \
    sudo passwd shadow-utils nss_wrapper \
 && dnf -y install 'dnf-command(copr)' \
 && dnf -y copr enable openfoam/openfoam \
 && dnf -y install ${PACKAGE} \
 && dnf -y clean all

# ---------------
# User management
# - nss-wrapper
# - openfoam sandbox directory

FROM runtime AS user
COPY openfoam-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/post-install.sh -fix-perms

ENTRYPOINT [ "/openfoam/run" ]

# ---------------------------------------------------------------------------
