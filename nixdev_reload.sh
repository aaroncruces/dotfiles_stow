#!/usr/bin/env bash
bash stow_uninstall_nixdev.sh
bash stow_uninstall_desktop.sh
bash stow_uninstall_common.sh

bash stow_install_common.sh
bash stow_install_desktop.sh
bash stow_install_nixdev.sh