# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add development layer onto the openfoam '-run' (Ubuntu) image.
#
# Example
#     docker build -f openfoam-dev.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2112 ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2106

FROM opencfd/openfoam${FOAM_VERSION}-run
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-dev
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------
