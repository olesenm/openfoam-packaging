# --------------------------------*- sh -*-----------------------------------
# File: /openfoam/assets/prebuild.sh
#
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# A post-installation setup adjustment for build environment
#
# ------------------------------------------------------------------------
# General setup

if [ -d /openfoam ]
then
    echo "# Permissions on /openfoam and entry point(s)" 1>&2
    chmod -R a+rX /openfoam

    if [ "$(id -u)" = 0 ]
    then
        chown -R root:root /openfoam
    fi

    for script in /openfoam/chroot /openfoam/run
    do
        [ -f "$script" ] && chmod 0755 "$script"
    done
    exit 0
else
    echo "# No /openfoam directory - stopping" 1>&2
    exit 1
fi


# ------------------------------------------------------------------------
