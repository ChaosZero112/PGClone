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
 for funcs in ${PGBLITZ_SRC}/functions/*.sh; do source $funcs; done
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
