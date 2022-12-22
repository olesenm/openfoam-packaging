# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Mininal ubuntu environment with dpkg functionality.
#
# Use the newest dpkg-scanpackages available.
# Can be useful when the local distribution (Ubuntu, openSUSE, Fedora, ...)
# has an older version.
#
# Ubuntu 21.10 introduced zstd compression, which older toolchains do not
# manage.
#
# Example
#
#     docker build -f dpkg-tools_ubuntu.Dockerfile .
#
#     docker build --build-arg OS_VER=jammy -t jammy-dpkg-tools ...
#
# ---------------------------------------------------------------------------
ARG OS_VER=latest

FROM ubuntu:${OS_VER} AS distro

FROM distro AS base0
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --fix-missing \
    apt-utils vim-tiny nano-tiny rsync wget ca-certificates \
    sudo passwd libnss-wrapper \
 && apt-get -y install --no-install-recommends \
    dpkg-dev \
 && rm -rf /var/lib/apt/lists/*


# ---------------
# User management
# - chroot

FROM base0 AS user
COPY build-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/prebuild.sh

ENTRYPOINT [ "/openfoam/chroot" ]

# ---------------------------------------------------------------------------
