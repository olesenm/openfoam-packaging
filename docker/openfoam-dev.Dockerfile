# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add development layer onto the openfoam '-run' (Ubuntu) image.
#
# Example
#     docker build -f openfoam-dev.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2306
#         -t opencfd/openfoam-dev:2306 ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2306

FROM opencfd/openfoam-run:${FOAM_VERSION}
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-dev
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------
