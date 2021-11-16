# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# RedHat-type of environment for building OpenFOAM with ThirdParty packages
# to target redhat/ubi images.
#
# The redhat/ubi image is freely available, but without a subscription
# it lacks even very basic tools such as flex or bison!
#
# Rocky Linux (bug-for-bug compatible with RHEL - ie, what CentOS was)
# provides RHEL compatible toolchains without the subscription.
#
# Provided that we avoid any copr or rocky-specific repositories,
# we can build with Rocky Linux and deploy for UBI images.
#
# Example
#
#     docker build -f build_ubifake.Dockerfile .
#
#     docker build --build-arg OS_VER=8 -t ubi8-build-openfoam ...
#
# UBI Library Availability
#     boost   - no
#     cgal    - no
#     fftw    - yes
#     openmpi - subscription
#     scotch  - no
#
#     libibverbs
# ---------------------------------------------------------------------------
ARG OS_VER=8

FROM rockylinux/rockylinux:${OS_VER} AS distro

FROM distro AS base0
RUN dnf -y install rsync wget bzip2 xz unzip \
    sudo passwd shadow-utils nss_wrapper \
    autoconf automake cmake make m4 patch pkgconf rpm-build \
    git \
    gcc-c++ glibc-devel gmp-devel mpfr-devel \
    bison flex readline-devel zlib-devel \
    fftw \
    fftw3-devel \
    libibverbs \
 && dnf -y clean all

# ---------------
# User management
# - chroot

FROM base0 AS user
COPY build-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/prebuild.sh

ENTRYPOINT [ "/openfoam/chroot" ]

# ---------------------------------------------------------------------------
