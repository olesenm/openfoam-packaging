# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Deployment of a self-container OpenFOAM package within a redhat/ubi
# container.
#
# All deployment assets are bundled into a 'deploy.tar' previously.
# These are then copied into the container in two steps.
#
# Example
#
#     docker build -f deploy_ubi.Dockerfile .
#
#     docker build --build-arg OS_VER=8
#
# ---------------------------------------------------------------------------
ARG OS_VER=8

FROM redhat/ubi${OS_VER} AS distro

FROM distro AS base0

# NEEDED? numactl compat-dapl dapl
RUN dnf -y install rsync wget bzip2 xz unzip \
    sudo passwd shadow-utils nss_wrapper hostname \
    openssh openssh-clients openssh-server \
    libibverbs nc \
    autoconf automake cmake make m4 patch pkgconf \
    gcc-c++ glibc-devel \
    gawk fftw \
 && dnf -y clean all \
 && sed -i -e '/^session.*pam_loginuid/s/required/optional/' /etc/pam.d/sshd

# -----------
# Staging
# - could also use ARG etc, but not yet needed
# - sideload everything into a dedicated directory

FROM base0 AS sideload
ADD  deploy.tar /sideload/openfoam/
COPY openfoam-files.rc/ /sideload/openfoam/
RUN  /bin/sh /sideload/openfoam/assets/fix-perms.sh

# -----------
# Final image, user management
# - copy everything from the sideload directory

FROM base0 AS application
COPY --from=sideload /sideload/openfoam/ /openfoam
RUN  /bin/sh /openfoam/assets/post-install.sh

ENTRYPOINT [ "/openfoam/run" ]

# ---------------------------------------------------------------------------
