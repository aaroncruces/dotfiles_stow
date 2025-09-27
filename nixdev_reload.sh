#! /bin/bash
bash stow_uninstall_desktop.sh
bash stow_uninstall_common.sh
git pull
bash stow_install_common.sh
bash stow_install_desktop.sh