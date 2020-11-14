#!/bin/bash
#
# Title:      PGBlitz.com (Reference Title File - PGBlitz)
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
set_location () {
    if [ $standalone == 0 ] || [ -z $standalone ]; then
        export PGBLITZ_DIR=/pg/pgclone
        export PGBLITZ_SRC=/pg/pgclone
    fi
}

set_location
################################################################################
source  ${PGBLITZ_SRC}/functions/functions.sh
source  ${PGBLITZ_SRC}/functions/variables.sh
source  ${PGBLITZ_SRC}/functions/mountnumbers.sh
source  ${PGBLITZ_SRC}/functions/keys.sh
source  ${PGBLITZ_SRC}/functions/keyback.sh
source  ${PGBLITZ_SRC}/functions/pgclone.sh
source  ${PGBLITZ_SRC}/functions/gaccount.sh
source  ${PGBLITZ_SRC}/functions/publicsecret.sh
source  ${PGBLITZ_SRC}/functions/transportselect.sh
source  ${PGBLITZ_SRC}/functions/projectname.sh
source  ${PGBLITZ_SRC}/functions/clonestartoutput.sh
source  ${PGBLITZ_SRC}/functions/oauth.sh
source  ${PGBLITZ_SRC}/functions/passwords.sh
source  ${PGBLITZ_SRC}/functions/oauthcheck.sh
source  ${PGBLITZ_SRC}/functions/keysbuild.sh
source  ${PGBLITZ_SRC}/functions/emails.sh
source  ${PGBLITZ_SRC}/functions/deploy.sh
source  ${PGBLITZ_SRC}/functions/rcloneinstall.sh
source  ${PGBLITZ_SRC}/functions/deploytransfer.sh
source  ${PGBLITZ_SRC}/functions/deploysdrive.sh
source  ${PGBLITZ_SRC}/functions/multihd.sh
source  ${PGBLITZ_SRC}/functions/deploylocal.sh
source  ${PGBLITZ_SRC}/functions/createsdrive.sh
source  ${PGBLITZ_SRC}/functions/cloneclean.sh
source  ${PGBLITZ_SRC}/functions/uagent.sh
################################################################################

# (rcloneinstall.sh) Install rclone
rcloneinstall

# (functions.sh) Ensures variables and folders exist
pgclonevars

# (functions.sh) User cannot proceed until they set transport and data type
mustset

# (functions.sh) Ensures that fuse is set correct for rclone
rcpiece

clonestart
