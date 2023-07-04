# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2023 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# openSUSE Leap environment for building OpenFOAM packages,
# uses system and science packages wherever possible.
#
# Example
#
#     docker build -f build_leap.Dockerfile .
#
#     docker build --build-arg OS_VER=15.5 -t leap-build-openfoam ...
#
# ---------------------------------------------------------------------------
ARG OS_VER=15.5

FROM opensuse/leap:${OS_VER} AS distro

FROM distro AS base0
ARG MPI_TYPE=openmpi2

RUN zypper -n install -y rsync wget sudo nss_wrapper \
 && zypper -n install -y -t pattern devel_C_C++ \
 && zypper -n install -y cmake git rpm-build \
 && zypper -n install -y \
    gcc-c++ \
    flex libfl-devel \
    readline-devel zlib-devel \
    ${MPI_TYPE}-devel \
    fftw3-devel \
    libboost_system-devel \
    libboost_thread-devel \
    mpfr-devel gmp-devel \
 && zypper -n addrepo -f \
    'https://download.opensuse.org/repositories/science/$releasever/' science \
 && zypper -n --gpg-auto-import-keys refresh science \
 && zypper -n install -y \
    scotch-devel ptscotch-${MPI_TYPE}-devel \
    cgal-devel \
 && zypper -n clean


# ---------------
# User management
# - chroot

FROM base0 AS user
COPY build-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/prebuild.sh

ENTRYPOINT [ "/openfoam/chroot" ]

# ---------------------------------------------------------------------------
