# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add development layer onto the openfoam '-run' image
#
# docker build -f openfoam-dev.Dockerfile .

FROM opencfd/openfoam2106-run

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    openfoam2106-dev \
 && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------
