#!/bin/bash
#
# Title:      PGBlitz.com (Reference Title File - PGBlitz)
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

export standalone=1
export PGBLITZ_DIR=/pg/pgclone

################################################################################

# Install required software and make Python 3's pip (pip3) default
software () {
    apt-get update && \
    apt-get install -y \
      jq \
      nano \
      git \
      build-essential \
      libssl-dev \
      libffi-dev \
      mergerfs \
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

  ## Copy pip to /usr/bin
  cp /usr/local/bin/pip3 /usr/bin/pip
  cp /usr/local/bin/pip3 /usr/bin/pip3

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

# Create necessary folders, based on PGBLITZ_DIR value
folder_gen () {
    if [[ ! -e ${PGBLITZ_DIR} ]]; then
        mkdir -p ${PGBLITZ_DIR}
        chown 1000:1000 ${PGBLITZ_DIR}
        chmod 0775 ${PGBLITZ_DIR}
        echo "Generated Folder: ${PGBLITZ_DIR}"
    else
        while true; do
            if [[ -z $overwrite ]]; then
            echo -e ""
            echo -e "\e[93m*****************************************************\e[0m"
            echo -e ""
            echo -e "The install directory of ${PGBLITZ_DIR} already exists."
            read -p "Overwrite? (Caution: All data will be lost!) [Y/n] " overwrite
            fi
            case $overwrite in
                [Yy]* ) rm -r ${PGBLITZ_DIR}
                    mkdir -p ${PGBLITZ_DIR}
                    chown 1000:1000 ${PGBLITZ_DIR}
                    chmod 0775 ${PGBLITZ_DIR}
                    echo "Generated Folder: ${PGBLITZ_DIR}"
                    break
                    ;;
                [Nn]* ) echo -e ""
                    echo "User aborted."
                    echo -e ""
                    echo -e "\e[31mTip: To change the install directory from the default /pg/pgclone"
                    echo -e "set the PGBLITZ_DIR variable to the location of your choosing. eg:\e[0m"
                    echo "PGBLITZ_DIR=\"/my/dir\" bash install.sh"
                    exit 1
                    ;;
                * ) echo -e "\e[31mInvalid input:\e[0m $overwrite."
                    echo "Please answer \"y\" for yes or \"n\" for no."
                    unset overwrite
                    ;;
            esac
        done
    fi
    unset overwrite
    if [[ -e ${PGBLITZ_DIR}-src ]]; then
        while true; do
            if [[ -z $overwrite ]]; then
            echo -e ""
            echo -e "\e[93m**********************************************************************\e[0m"
            echo -e ""
            echo -e "The source code directory of ${PGBLITZ_DIR}-src already exists."
            read -p "Overwrite? (Caution: Source will be reverted to current v10 branch) [Y/n] " overwrite
            fi
            case $overwrite in
                [Yy]* ) rm -r ${PGBLITZ_DIR}-src
                    break
                    ;;
                [Nn]* ) echo -e ""
                    echo "User aborted."
                    echo -e ""
                    exit 1
                    ;;
                * ) echo -e "\e[31mInvalid input:\e[0m $overwrite."
                    echo "Please answer \"y\" for yes or \"n\" for no."
                    unset overwrite
                    ;;
            esac
        done
    fi
    unset overwrite
}

# Clone the git environment
git_environment () {
    git clone --branch v10 https://github.com/ChaosZero112/PGClone.git ${PGBLITZ_DIR}-src
}

# Execute
software
folder_gen
git_environment
( cd ${PGBLITZ_DIR}-src && . ${PGBLITZ_DIR}-src/pgclone.sh )
exit 0