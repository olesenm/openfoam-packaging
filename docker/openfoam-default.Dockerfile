# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2024 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0-or-later)
#
# Add default (tutorials etc) layer onto the openfoam '-dev' (Ubuntu) image.
#
# Example
#     docker build -f openfoam-default.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2406
#         -t opencfd/openfoam-default:2406 ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2406

FROM opencfd/openfoam-dev:${FOAM_VERSION}
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-default
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------
