# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Create openfoam '-run' image for Rocky Linux using copr repo.
#
# Example
#     docker build -f openfoam-run_rocky.Dockerfile .
#     docker build --build-arg OS_VER=8 --build-arg FOAM_VERSION=2212 ...
#
# ---------------------------------------------------------------------------
ARG OS_VER=latest

FROM rockylinux/rockylinux:${OS_VER} AS distro

FROM distro AS runtime
ARG FOAM_VERSION=2212
ARG PACKAGE=openfoam${FOAM_VERSION}

RUN dnf -y install wget rsync \
    sudo passwd shadow-utils nss_wrapper \
 && dnf -y install 'dnf-command(config-manager)' \
 && dnf -y config-manager --set-enabled powertools \
 && dnf -y install epel-release \
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
