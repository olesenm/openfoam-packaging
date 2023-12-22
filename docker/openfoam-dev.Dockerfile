# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2023 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0-or-later)
#
# Add development layer onto the openfoam '-run' (Ubuntu) image.
#
# Example
#     docker build -f openfoam-dev.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2312
#         -t opencfd/openfoam-dev:2312 ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2312

FROM opencfd/openfoam-run:${FOAM_VERSION}
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-dev
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------
