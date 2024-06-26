# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0-or-later)
#
# Ubuntu environment for building OpenFOAM packages,
# uses system packages wherever possible.
#
# Example
#
#     docker build -f build_ubuntu.Dockerfile .
#
#     docker build --build-arg OS_VER=noble -t noble-build-openfoam ...
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
 && apt-get -y install \
    dh-make build-essential autoconf autotools-dev cmake gawk \
    autopkgtest lintian git git-buildpackage \
 && apt-get -y install --no-install-recommends \
    flex libfl-dev libreadline-dev zlib1g-dev \
    gfortran \
    openmpi-bin libopenmpi-dev \
    mpi-default-bin mpi-default-dev \
    libscotch-dev libptscotch-dev \
    libfftw3-dev \
    libboost-system-dev libboost-thread-dev \
    libcgal-dev \
 && rm -rf /var/lib/apt/lists/*


# ---------------
# User management
# - chroot

FROM base0 AS user
COPY build-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/prebuild.sh

ENTRYPOINT [ "/openfoam/chroot" ]

# ---------------------------------------------------------------------------
