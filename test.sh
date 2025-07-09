#!/bin/bash

# ==============================================================================
#   Automatisches Setup-Skript für eine minimalistische Debian 12 Installation
# ==============================================================================
#   Dieses Skript konfiguriert ein System mit:
#   - X.Org Display-Server
#   - Ly Login-Manager
#   - i3 Window Manager
#   - Kitty, Rofi, Polybar, Dunst, Nitrogen
#   - PipeWire, NetworkManager, Brave Browser und essenzielle Tools
# ==============================================================================

# --- GRUNDEINSTELLUNGEN UND SICHERHEITSCHECKS ---

# Das Skript bei einem Fehler sofort beenden
set -e

# Sicherstellen, dass das Skript mit sudo ausgeführt wird
if [ "$(id -u)" -ne 0 ]; then
  echo "FEHLER: Bitte führe dieses Skript mit 'sudo' aus." >&2
  exit 1
fi

echo "=================================================="
echo "  Automatisches Debian Setup-Skript"
echo "=================================================="
echo "Das System wird jetzt aktualisiert und konfiguriert."
read -p "Möchtest du fortfahren? (j/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[jJ]$ ]]; then
    exit 1
fi

# --- 1. SYSTEM-VORBEREITUNG: APT-Quellen und Updates ---

echo "--> [1/7] Konfiguriere APT-Quellen und aktualisiere das System..."

# APT-Quellen um contrib, non-free und non-free-firmware erweitern
sed -i 's/ main/ main contrib non-free non-free-firmware/g' /etc/apt/sources.list

# System aktualisieren
apt update
apt upgrade -y

# --- 2. INSTALLATION DER FUNDAMENT-PAKETE UND HARDWARE-SUPPORT ---

echo "--> [2/7] Installiere fundamentale Systemwerkzeuge und Firmware..."
apt install -y \
    build-essential \
    firmware-linux-nonfree \
    man-db \
    manpages-de \
    bash-completion \
    git \
    curl \
    wget \
    unzip \
    zip \
    p7zip-full \
    htop \
    tldr \
    ripgrep \
    bat \
    ttf-mscorefonts-installer

# --- 3. INSTALLATION DER GRAFISCHEN UMGEBUNG (X11 & i3) ---

echo "--> [3/7] Installiere X.Org, i3 WM und wichtige Begleiter..."
apt install -y \
    xserver-xorg-core \
    xinit \
    i3 \
    kitty \
    rofi \
    polybar \
    nitrogen \
    dunst \
    thunar \
    libglib2.0-bin # Für gsettings, oft von GTK-Apps wie Thunar benötigt

# --- 4. INSTALLATION VON AUDIO- (PIPEWIRE) UND NETZWERK-SUPPORT (NETWORKMANAGER) ---

echo "--> [4/7] Installiere PipeWire Audio-Server und NetworkManager..."
apt install -y \
    pipewire \
    pipewire-audio \
    wireplumber \
    network-manager

# --- 5. INSTALLATION DES BRAVE BROWSERS (EXTERNES REPOSITORY) ---

echo "--> [5/7] Installiere den Brave Browser..."
# GPG-Schlüssel hinzufügen
install -m 0755 -d /etc/apt/keyrings
curl -fsSLo /etc/apt/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
# Repository hinzufügen
echo "deb [signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
# Installieren
apt update
apt install -y brave-browser

# --- 6. INSTALLATION VON SCHRIFTARTEN (NERD FONT) ---

echo "--> [6/7] Installiere Hack Nerd Font..."
# Nerd Fonts sind nicht direkt in Debian, wir laden sie manuell herunter
# Wir nutzen die offizielle Methode von Nerd Fonts für die Installation
mkdir -p /usr/local/share/fonts/NerdFonts
cd /usr/local/share/fonts/NerdFonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip
unzip Hack.zip
rm Hack.zip
# Font-Cache neu aufbauen
fc-cache -fv
cd ~

# --- 7. INSTALLATION UND KONFIGURATION DES LY LOGIN-MANAGERS ---

echo "--> [7/7] Installiere und konfiguriere den Ly Login-Manager..."
# Abhängigkeiten für den Build-Prozess installieren
apt install -y libpam0g-dev libxcb-xkb-dev
# Ly von GitHub klonen
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
# Kompilieren und installieren
make
make install
# Den Systemd-Dienst für Ly aktivieren, damit er beim Booten startet
systemctl enable ly.service
cd ~
rm -rf ly # Aufräumen

# --- ABSCHLUSS ---

echo "=================================================="
echo "  Setup abgeschlossen!"
echo "=================================================="
echo "WICHTIG:"
echo "1. Das System wird jetzt neu gestartet, um alle Änderungen zu übernehmen."
echo "2. Nach dem Neustart wirst du vom Ly Login-Manager begrüßt."
echo "3. Logge dich ein, um deine i3-Sitzung zu starten."
echo "4. Beim ersten i3-Start: Drücke ENTER, um die Standardkonfiguration zu erstellen."
echo "   Du wirst gefragt, welchen Modifier du nutzen willst (Win oder Alt). Wähle einen aus."
echo ""
read -p "Drücke ENTER, um das System jetzt neu zu starten."
reboot
