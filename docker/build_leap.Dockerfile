# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# openSUSE Leap environment for building OpenFOAM packages,
# uses system and science packages wherever possible.
#
# Example
#
#     docker build -f build_leap.Dockerfile .
#
#     docker build --build-arg OS_VER=15.3 -t leap-build-openfoam ...
#
# ---------------------------------------------------------------------------
ARG OS_VER=15.3

FROM opensuse/leap:${OS_VER} AS distro

FROM distro AS base0
ARG OS_VER

RUN zypper install -y rsync wget sudo nss_wrapper \
 && zypper install -y -t pattern devel_C_C++ \
 && zypper install -y cmake git rpm-build \
 && zypper install -y \
    flex libfl-devel \
    readline-devel zlib-devel \
    openmpi-devel \
    fftw3-devel \
    libboost_system-devel \
    libboost_thread-devel \
    mpfr-devel gmp-devel \
 && zypper -n addrepo -f --no-gpgcheck \
    https://download.opensuse.org/repositories/science/openSUSE_Leap_${OS_VER}/science.repo \
 && zypper --no-gpg-checks refresh science \
 && zypper install -y \
    scotch-devel ptscotch-openmpi-devel \
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
