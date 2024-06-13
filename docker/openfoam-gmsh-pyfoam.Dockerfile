# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2024 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0-or-later)
#
# Example file
# - adds gmsh, PyFoam layer onto the openfoam '-dev' (Ubuntu) image.
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2406

FROM opencfd/openfoam-dev:${FOAM_VERSION}
ARG FOAM_VERSION
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y pip \
 && rm -rf /var/lib/apt/lists/* \
 && pip install gmsh meshio pygmsh pyfoam


# ---------------------------------------------------------------------------
