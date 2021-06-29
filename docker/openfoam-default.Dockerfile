# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add default (tutorials etc) layer onto the openfoam '-dev' image
#
# docker build -f openfoam-default.Dockerfile .

FROM opencfd/openfoam2106-dev

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    openfoam2106-default \
 && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------
