#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# main dependencies #
# 22 Aug 2024 - NOTE will trim this more down


# packages neeeded
dependencies=(
    build-essential
    cmake
    cmake-extras
    curl
    findutils
    gawk
    gettext
    git
    glslang-tools
    gobject-introspection
    golang
    hwdata
    jq
    libegl-dev
    libegl1-mesa-dev
    meson
    ninja-build
    openssl
    psmisc
    python3-mako
    python3-markdown
    python3-markupsafe
    python3-yaml
    python3-pyquery
    qt6-base-dev
    spirv-tools
    unzip
    vulkan-validationlayers
    vulkan-utility-libraries-dev
    wayland-protocols
    xdg-desktop-portal
    xwayland
    # Hinzugefügte Build-Abhängigkeiten für hyprcursor (gemäß GitHub-Doku)
    librsvg2-dev # Abhängigkeit für librsvg
    libzip-dev # Abhängigkeit für libzip
    libtomlplusplus-dev # Abhängigkeit für tomlplusplus
)

# hyprland dependencies
hyprland_dep=(
    bc
    binutils
    libc6
    libcairo2
    libdisplay-info2
    libdrm2
    # libhyprcursor-dev wurde entfernt, da wir es jetzt selbst bauen
    libhyprlang-dev # hyprlang ist weiterhin ein Paket, falls es in Debian verfügbar ist.
    libpam0g-dev
    # hyprcursor-util wird mit hyprcursor gebaut, daher hier entfernt
)

build_dep=(
  wlroots
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_dependencies.log"

# Installation of main dependencies
printf "\n%s - Installing ${SKY_BLUE}main dependencies....${RESET} \n" "${NOTE}"

for PKG1 in "${dependencies[@]}"; do # Nur "dependencies" hier, da hyprland_dep später verarbeitet wird
  install_package "$PKG1" "$LOG"
done

# Zusätzliche Installation der hyprland_dep (inkl. libhyprlang-dev)
printf "\n%s - Installing ${SKY_BLUE}Hyprland specific dependencies....${RESET} \n" "${NOTE}"
for PKG1 in "${hyprland_dep[@]}"; do
  install_package "$PKG1" "$LOG"
done


printf "\n%.0s" {1..1}

for PKG1 in "${build_dep[@]}"; do
  build_dep "$PKG1" "$LOG"
done

# HINZUFÜGEN DIESER NEUEN SEKTION FÜR HYPRCURSOR BUILD:
# Dieser Teil wird NACH allen apt-Paketen (einschließlich libdrm2) ausgeführt.
printf "\n%s - Building and installing ${SKY_BLUE}hyprcursor from source....${RESET} \n" "${NOTE}"
build_hyprcursor "$LOG" # Ruft die neu erstellte Funktion auf
if [ $? -ne 0 ]; then
  echo "${ERROR} hyprcursor build failed. Exiting."
  exit 1
fi
printf "\n%.0s" {1..2}


# Hier würde der restliche Teil deines JaKooLit Skripts weitergehen,
# z.B. das Kompilieren und Installieren von Hyprland selbst.
# ...