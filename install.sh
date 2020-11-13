#!/bin/bash
#
# Title:      PGBlitz.com (Reference Title File - PGBlitz)
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

software () {
    apt-get update && \
    apt-get install -y --reinstall \
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
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==20.2.4
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
      pyOpenSSL \
      requests \
      netaddr \
      lxml
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall ansible==2.10.3

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

folder_gen () {
    if [[ ! -e "/pg/pgclone" ]]; then
        mkdir -p /pg/pgclone
        chown 1000:1000 /pg/pgclone
        chmod 0775 /pg/pgclone; fi
        echo "Generated Folder: /pg/pgclone"
    else
        while true; do
            if [[ -z $overwrite ]]; then
            read -p "/pg/pgclone exists. Overwrite? (Caution: All data will be lost!) [Y/n] " overwrite
            fi
            case $overwrite in
                [Yy]* ) rm -r /pg/pgclone
                    mkdir -p /pg/pgclone
                    chown 1000:1000 /pg/pgclone
                    chmod 0775 /pg/pgclone; fi
                    echo "Generated Folder: /pg/pgclone"
                    break
                    ;;
                [Nn]* ) echo "User aborted."
                    exit 1
                    ;;
                * ) echo -e "\e[31mInvalid input:\e[0m $overwrite."
                    echo "Please answer \"y\" for yes or \"n\" for no."
                    unset overwrite
                    ;;
            esac
        done
    fi
}
git_environment () {
    git clone --branch v10 https://github.com/ChaosZero112/PGClone.git /pg/pgclone
    export standalone=1
    export PGBLITZ_DIR=/pg/rclone
}

software
folder_gen
git_environment
cd /pg/pgclone
exec /pg/pgclone/pgclone.sh
exit 0