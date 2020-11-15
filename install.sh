#!/bin/bash
#
# Title:      PGBlitz.com (Reference Title File - PGBlitz)
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

set_environment () {
    export standalone=1
    if [ -z ${PGBLITZ_DIR} ]; then
        export PGBLITZ_DIR=/pg/pgclone
    else
        if [[ "${PGBLITZ_DIR:0:1}" == / ]]; then
            #do nothing
            export ${PGBLITZ_DIR}=${PGBLITZ_DIR}
        elif [[ -v $PGBLITZ_DIR ]]; then
            export PGBLITZ_DIR=/${PGBLITZ_DIR}
        fi
    fi
    if [ -z ${PGBLITZ_SRC} ]; then
        export PGBLITZ_SRC=${PGBLITZ_DIR}-src
    else
        if [[ "${PGBLITZ_SRC:0:1}" == / ]]; then
            #do nothing
            export ${PGBLITZ_SRC}=${PGBLITZ_SRC}
        else
            export PGBLITZ_SRC=/${PGBLITZ_SRC}
        fi
    fi
}

# Install required software and make Python 3's pip (pip3) default
software () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💿 Installing Required Software ~ Please wait
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    apt-get update >/dev/null && \
    apt-get install -y -qq \
      jq \
      nano \
      git \
      build-essential \
      libssl-dev \
      libffi-dev \
      mergerfs \
      apt-transport-https \
      ca-certificates \
      gnupg \
      python3-dev \
      python3-testresources \
      python3-pip \
      python3-testresources
  python3 -m pip install --disable-pip-version-check --upgrade pip==20.2.4
  python3 -m pip install --disable-pip-version-check --upgrade setuptools
  python3 -m pip install --disable-pip-version-check --upgrade \
      pyOpenSSL \
      requests \
      netaddr \
      lxml
  python3 -m pip install --disable-pip-version-check --upgrade ansible==2.10.3

  # Google SDK
    echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    apt-get update >/dev/null && \
    apt-get -y -qq install google-cloud-sdk

  ## Copy pip to /usr/bin
  cp /usr/local/bin/pip3 /usr/bin/pip
  cp /usr/local/bin/pip3 /usr/bin/pip3

  # Ansible config
  mkdir -p /etc/ansible/inventories/ 1>/dev/null 2>&1
  echo "[local]" > /etc/ansible/inventories/local
  echo "127.0.0.1 ansible_connection=local" >> /etc/ansible/inventories/local

  ### Reference: https://docs.ansible.com/ansible/2.4/intro_configuration.html
  echo "[defaults]" > /etc/ansible/ansible.cfg
  echo "command_warnings = False" >> /etc/ansible/ansible.cfg
  echo "callback_whitelist = profile_tasks" >> /etc/ansible/ansible.cfg
  echo "inventory = /etc/ansible/inventories/local" >> /etc/ansible/ansible.cfg

  # Remove Cows when cowsay installed on main system
  echo "nocows = 1" >> /etc/ansible/ansible.cfg
}

fcreate () {
    if [[ ! -e "$1" ]]; then
        mkdir -p "$1"
        chown 1000:1000 "$1"
        chmod 0775 "$1"; fi
        echo "Generated Folder: $1"
}

# Create necessary folders, based on PGBLITZ_DIR value
folder_gen () {
    if [[ ! -e ${PGBLITZ_DIR} ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Creating Required Folders
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        fcreate ${PGBLITZ_DIR}
        fcreate /pg
        fcreate /pg/logs
        fcreate /pg/gc
        fcreate /pg/gd
        fcreate /pg/sc
        fcreate /pg/sd
        fcreate /pg/transfer
        fcreate /pg/transport
        fcreate ${PGBLITZ_DIR}/rclone
        fcreate ${PGBLITZ_DIR}/var
    else
        while true; do
            if [[ -z $overwrite ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠ Directory Exists
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
The install directory of ${PGBLITZ_DIR} already exists.

1. You may choose to continue without touching the existing folder (this
is likely the option you want) or 

2. You can choose to wipe the existing folder and all data within the
directory will be lost. (Note: You will lose any previous configurations!)

[1] Continue without wipe (keep settings)
[2] Continue and wipe (erase settings)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
            read -rp '↘️  Input Selection | Press [ENTER]: ' overwrite < /dev/tty
            fi
            case $overwrite in
                [1]* ) tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
👉 Continuing without wiping
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
                break
                ;;
                [2]* ) rm -r ${PGBLITZ_DIR}
                break
                ;;
                [NnZz]* ) tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚫 User Aborted
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

\e[31mTip: To change the install directory from the default /pg/pgclone"
set the PGBLITZ_DIR variable to the location of your choosing. eg:\e[0m"
PGBLITZ_DIR=\"/my/dir\" bash install.sh"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
                    exit 1
                    ;;
                * ) echo -e "\e[31mInvalid input:\e[0m $overwrite."
                    echo -e ""
                    echo "Please select a valid option (1, 2, or Z)."
                    unset overwrite
                    ;;
            esac
        done
    fi
    unset overwrite
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Creating Required Folders
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    fcreate ${PGBLITZ_DIR}
    fcreate /pg
    fcreate /pg/logs
    fcreate /pg/gc
    fcreate /pg/gd
    fcreate /pg/sc
    fcreate /pg/sd
    fcreate /pg/transfer
    fcreate /pg/transport
    fcreate ${PGBLITZ_DIR}/rclone
    fcreate ${PGBLITZ_DIR}/var

    if [[ -e ${PGBLITZ_SRC} ]]; then
        while true; do
            if [[ -z $overwrite ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠ Directory Exists
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
The source code directory of ${PGBLITZ_SRC} already exists.
If you choose to continue, folder will be reset to the current v10 branch.
All changes (if any) will be lost.
(This does not affect any configurations and is likely safe to continue.)

[1] Continue
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
            read -rp '↘️  Input Selection | Press [ENTER]: ' overwrite < /dev/tty
            fi
            case $overwrite in
                [1Yy]* ) rm -r ${PGBLITZ_SRC}
                    break
                    ;;
                [ZzNn]* ) tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚫 User Aborted
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
                    exit 1
                    ;;
                * ) echo -e ""
                    echo "Please select a valid option (1 or Z)."
                    unset overwrite
                    ;;
            esac
        done
    fi
    unset overwrite
}

# Clone the git environment
git_environment () {
    git clone -q --branch v10 https://github.com/ChaosZero112/PGClone.git ${PGBLITZ_SRC}
}

# Execute
set_environment
software
folder_gen
git_environment
( cd ${PGBLITZ_SRC} && . ${PGBLITZ_SRC}/pgclone.sh )
exit 0