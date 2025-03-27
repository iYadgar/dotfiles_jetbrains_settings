#! /usr/bin/zsh

DOTFILES_DIR="${HOME}/.dotfiles"
ZSH_CUSTOM_DIR="${HOME}/.oh-my-zsh/custom"
set -eu

function install_dotfiles() {
  local source="${1:-}"
  local target="${2:-}"
  if test ! -e "${source:-}"; then return 0; fi

  while read -r file; do
      relative_file_path="${file#"${source}"/}"
      target_file="${target}/${relative_file_path}"
      target_dir="${target_file%/*}"

      if test ! -d "${target_dir}"; then
          mkdir -p "${target_dir}"
      fi

      printf 'Installing dotfiles symlink %s\n' "${target_file}"
      ln -sf "${file}" "${target_file}"
  done < <(find "${source}" -type f)
}

current_dir="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

install_dotfiles "${current_dir}/home_files" "${HOME}"
install_dotfiles "${current_dir}/workspace_repo" "${GITPOD_REPO_ROOT}"
ln -sf "${DOTFILES_DIR}/custom-zsh-config.zsh" "${ZSH_CUSTOM_DIR}/custom-zsh-config.zsh"

if test ! -e /usr/bin/commitjb; then
    sudo ln -s "${current_dir}/commitjb" /usr/bin/
fi

# workspace_xml="${GITPOD_REPO_ROOT}/.idea/workspace.xml"
# # if test -e "${workspace_xml}"; then
#   function watch_workspace_xml() {
#       tail -n 0 -F "${workspace_xml}" 2>/dev/null | while read -r line; do
#           commitjb
#           break;
#       done || true;
#       watch_workspace_xml;
#   }
#   watch_workspace_xml & disown
# fi

#########################################
# WebStorm Settings Installation Section
#########################################

webstorm_zip="${current_dir}/WebStorm_Settings.zip"
if [ -f "$webstorm_zip" ]; then
  echo "📦 Installing WebStorm settings from $webstorm_zip"

  # Detect OS and set JetBrains config dir
  case "$(uname -s)" in
    Darwin)
      JETBRAINS_DIR="${HOME}/Library/Application Support/JetBrains"
      ;;
    Linux)
      if grep -qi microsoft /proc/version; then
        # WSL (Windows Subsystem for Linux)
        JETBRAINS_DIR="${HOME}/AppData/Roaming/JetBrains"
      else
        JETBRAINS_DIR="${HOME}/.config/JetBrains"
      fi
      ;;
    *)
      echo "❌ Unsupported OS. Skipping WebStorm settings installation."
      exit 1
      ;;
  esac

  # Find the latest WebStorm config directory
  WEBSTORM_DIR=$(find "$JETBRAINS_DIR" -type d -name "WebStorm*" 2>/dev/null | sort -r | head -n 1)

  if [ -z "$WEBSTORM_DIR" ]; then
    echo "❌ WebStorm config directory not found under $JETBRAINS_DIR. Skipping settings import."
  else
    echo "✅ Found WebStorm config directory at: $WEBSTORM_DIR"

    # Backup current config
    BACKUP_DIR="${WEBSTORM_DIR}-backup-$(date +%Y%m%d%H%M%S)"
    echo "📁 Backing up existing settings to $BACKUP_DIR"
    cp -R "$WEBSTORM_DIR" "$BACKUP_DIR"

    # Unzip into temporary location
    TEMP_DIR="/tmp/webstorm-settings"
    echo "📂 Extracting settings to $TEMP_DIR"
    rm -rf "$TEMP_DIR"
    unzip -o "$webstorm_zip" -d "$TEMP_DIR"

    # Copy to WebStorm config directory
    echo "📥 Copying settings into $WEBSTORM_DIR"
    cp -R "$TEMP_DIR"/* "$WEBSTORM_DIR"

    echo "✅ WebStorm settings successfully installed."
    rm -rf "$TEMP_DIR"
  fi
else
  echo "⚠️ WebStorm_Settings.zip not found. Skipping WebStorm config install."
fi
