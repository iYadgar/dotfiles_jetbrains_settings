#!/usr/bin/env bash
set -eu

DOTFILES_DIR="${HOME}/.dotfiles"
DOTFILES_WORKSPACE_REPO_DIR="${DOTFILES_DIR}/workspace_repo"
DOTFILES_HOME_DIR="${DOTFILES_DIR}/home_files"
PERSISTENT_JB_DIR="${HOME}/.gitpod/jetbrains/${JETBRAINS_GITPOD_BACKEND_KIND:-}"
PERSISTENT_DOTFILES_DIR="${DOTFILES_HOME_DIR}/${PERSISTENT_JB_DIR#$HOME/}"
EPHEMERAL_JB_OPTIONS_DIR=(/workspace/.config/JetBrains/RemoteDev-*/options)

(
    mkdir -p "${PERSISTENT_DOTFILES_DIR}"
    cp -ar "${EPHEMERAL_JB_OPTIONS_DIR}" "${PERSISTENT_DOTFILES_DIR}" 2>/dev/null

    # home/.config dir
    if test -e "${HOME}/.config/JetBrains"; then
        mkdir -p "${DOTFILES_HOME_DIR}/.config"
        cp -ar "${HOME}/.config/JetBrains" "${DOTFILES_HOME_DIR}/.config" || :
    fi

    # .idea/workspace.xml for persisting IDE UI layout and etc.
    workspace_xml="${GITPOD_REPO_ROOT}/.idea/workspace.xml"
    if test -e "${workspace_xml}"; then
      mkdir -p "${DOTFILES_WORKSPACE_REPO_DIR}/.idea"
      cp -ar "${workspace_xml}" "${DOTFILES_WORKSPACE_REPO_DIR}/.idea" || :
    fi

    "$HOME/.dotfiles/install.sh"
    cd "${DOTFILES_DIR}"
    git add .
    git commit -m 'Automatic commit for updating Jetbrains config'
    git push
)

printf '[info] %s\n' "Successfully cloned ${EPHEMERAL_JB_OPTIONS_DIR} contents to a persistent location"
