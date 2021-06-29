# --------------------------------*- sh -*-----------------------------------
# File: /openfoam/assets/post-install.sh
#
# Copyright (C) 2020-2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# A post-installation setup adjustment (OpenFOAM container environment)
#
# ------------------------------------------------------------------------
# General setup
echo "# Home directory for container user: /home/openfoam" 1>&2
[ -d "/home/openfoam" ] || mkdir -p /home/openfoam

echo "# Permissions on /openfoam and entry point" 1>&2
chmod -R a+rX /openfoam
chmod 0755 /openfoam/run


# ------------------------------------------------------------------------
# Pseudo-admin user 'sudofoam' and a sudoers entry for that user
#
# None of this is particularly secure, but if we wish to grant unlimited
# sudo rights, this is what it takes

sudo_user=sudofoam

if [ "${sudo_user:-none}" != none ] \
 && /usr/sbin/useradd \
        --comment "sudo user for openfoam container" \
        --user-group \
        --create-home \
        --shell /bin/bash \
        ${sudo_user}
then
    echo "# Added user and sudo content for <$sudo_user> admin-user" 1>&2

    if [ -x /usr/bin/passwd ]
    then
        cat<<-__EOF__ | /usr/bin/passwd $sudo_user 2>/dev/null
	foam
	foam
	__EOF__
    fi
    if [ -d /etc/sudoers.d ]
    then
        cat<<-__EOF__ > /etc/sudoers.d/openfoam
	## An 'admin' user name for sudo within openfoam container
	${sudo_user} ALL=(ALL) NOPASSWD:ALL
	## END
	__EOF__
        chmod 0440 /etc/sudoers.d/openfoam
    else
        echo "Warning: no /etc/sudoers.d/" 1>&2
        echo "    perhaps sudo was not installed" 1>&2
    fi

# This does not seem to work:
#     cat<<-__EOF__ > /usr/bin/sudofoam
# #!/bin/sh
# # Run sudo via the ${sudo_user} user
# /usr/bin/su ${sudo_user} -c "/usr/bin/sudo \$@"
# #--
# __EOF__
#
#     chmod 0755 /usr/bin/sudofoam
else
    echo "# No sudo admin-account added" 1>&2
fi


# ------------------------------------------------------------------------

# Hooks for interactive bash
if [ -f /etc/bash.bashrc ]
then
    if grep -q -F /etc/bash.bashrc.local /etc/bash.bashrc
    then
        # SuSE: /etc/bash.bashrc.local
        echo "# Update /etc/bash.bashrc.local for openfoam" 1>&2
        cat <<__EOF__ >> /etc/bash.bashrc.local
# OpenFOAM environment
[ -f /openfoam/bash.rc ] && . /openfoam/bash.rc
__EOF__
    chmod 0644 /etc/bash.bashrc.local

    elif grep -q -F /openfoam/bash.rc /etc/bash.bashrc
    then
        echo "# /etc/bash.bashrc already adjusted" 1>&2
    else
        # Debian: /etc/bash.bashrc
        echo "# Update /etc/bash.bashrc for openfoam" 1>&2
        cat <<__EOF__ >> /etc/bash.bashrc

# OpenFOAM environment
[ -f /openfoam/bash.rc ] && . /openfoam/bash.rc
__EOF__
    fi
else
    echo "Warning: no /etc/bash.bashrc or /etc/bash.bashrc.local" 1>&2
fi


# Create/update profile

# Find the (latest) installed version
prefix=/usr/lib/openfoam
projectDir="$(/bin/ls -d "$prefix"/openfoam[0-9]* 2>/dev/null | sort -n | tail -1)"

if [ -d "$projectDir" ]
then
    package="${projectDir##*/}"
    echo "# Found openfoam=$package" 1>&2

    # Disposable 'sandbox'
    sandbox="$projectDir/sandbox"

    echo "# Define openfoam sandbox: $sandbox" 1>&2
    mkdir -p -m 1777 "$sandbox"

    # Generate /etc/profile.d/openfoam.sh
    sed -e 's#@PACKAGE@#'"${package}"'#g' \
        /openfoam/assets/profile.sh.in > /etc/profile.d/openfoam.sh

else
    echo "Warning: cannot find latest openfoam package" 1>&2
    echo "  /etc/profile.d/openfoam.sh - may require further adjustment" 1>&2

    # Generate /etc/profile.d/openfoam.sh
    cp -f /openfoam/assets/profile.sh.in /etc/profile.d/openfoam.sh
fi

if [ -f /etc/profile.d/openfoam.sh ]
then
    chmod 0644 /etc/profile.d/openfoam.sh
fi



# ---------------------------------------------------------------------------
