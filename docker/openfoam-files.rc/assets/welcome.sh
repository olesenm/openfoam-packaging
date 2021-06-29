# --------------------------------*- sh -*-----------------------------------
# File: /openfoam/assets/welcome.sh
#
# Copyright (C) 2020-2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# General information to display on startup (interactive shell)
#
# ------------------------------------------------------------------------

# Operating system name (may not be apparent for the user)
unset PRETTY_NAME
eval "$(sed -ne '/^PRETTY_NAME=/p' /etc/os-release 2>/dev/null)"

# Admin user
sudo_user=sudofoam
grep -q "^${sudo_user}:" /etc/passwd 2>/dev/null || unset sudo_user


# The (latest) installed version
prefix=/usr/lib/openfoam
projectDir="$(/bin/ls -d "$prefix"/openfoam[0-9]* 2>/dev/null | sort -n | tail -1)"

unset foam_api foam_patch foam_build release_notes

if [ -d "$projectDir" ]
then
    # META-INFO: api/patch/build values

    info="$projectDir/META-INFO/api-info"
    eval "$(sed -ne 's/^\(api\|patch\)=/foam_\1=/p' "$info" 2>/dev/null)"

    info="$projectDir/META-INFO/build-info"
    eval "$(sed -ne 's/^\(build\)=/foam_\1=/p' "$info" 2>/dev/null)"

    # Release notes: openfoam-vYYMM
    if [ -n "$foam_api" ]
    then
        release_notes="openfoam-v${foam_api}"
    fi
else
    unset projectDir
fi

# ---------------------------------------------------------------------------
# Output

exec 1>&2
cat<< '__BANNER__'
---------------------------------------------------------------------------
  =========                 |
  \\      /  F ield         | OpenFOAM in a container [from OpenCFD Ltd.]
   \\    /   O peration     |
    \\  /    A nd           | www.openfoam.com
     \\/     M anipulation  |
---------------------------------------------------------------------------
__BANNER__

cat<< __NOTES__
 Release notes:  https://www.openfoam.com/releases/${release_notes}
 Documentation:  https://www.openfoam.com/documentation/
 Issue Tracker:  https://develop.openfoam.com/Development/openfoam/issues/
 Local Help:     more /openfoam/README
---------------------------------------------------------------------------
System   :  ${PRETTY_NAME:-[]}${sudo_user:+  (admin user: $sudo_user)}
OpenFOAM :  ${projectDir:-[]}
__NOTES__

# Build information - stringify like OpenFOAM output
string="$foam_build"
if [ -n "$foam_api" ]
then
    string="${string}${string:+ }OPENFOAM=${foam_api}"
    [ -n "$foam_patch" ] && string="${string} patch=${foam_patch:-[]}"

    echo "Build    :  $string"
    cat<< '__NOTES__'

Note
    Different OpenFOAM components and modules may be present (or missing)
    on any particular container installation.
    Eg, source code, tutorials, in-situ visualization, paraview plugins,
        external linear-solver interfaces etc.
__NOTES__
fi

cat<< '__FOOTER__'

---------------------------------------------------------------------------
__FOOTER__

# ---------------------------------------------------------------------------
