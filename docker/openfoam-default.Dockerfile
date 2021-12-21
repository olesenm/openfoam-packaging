# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add default (tutorials etc) layer onto the openfoam '-dev' (Ubuntu) image.
#
# Example
#     docker build -f openfoam-default.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2112
#         -t opencfd/openfoam2112-dev ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2112

FROM opencfd/openfoam${FOAM_VERSION}-dev
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-default
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------
