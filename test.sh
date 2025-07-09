#!/bin/bash

# =================================================================
#  Installationsskript für ein personalisiertes i3-Setup auf Debian 12
# =================================================================

# --- SCHRITT 1: System aktualisieren ---
echo ">>> Schritt 1: System-Repositories werden aktualisiert..."
sudo apt update
echo ""

# --- SCHRITT 2: Installation der Hauptkomponenten ---
echo ">>> Schritt 2: Hauptpakete werden installiert (Xorg, i3, Tools)..."
sudo apt install -y \
    xorg \
    i3 \
    kitty \
    rofi \
    polybar \
    nitrogen \
    thunar \
    thunar-archive-plugin \
    picom \
    dunst \
    policykit-1-gnome \
    fonts-jetbrains-mono \
    fonts-font-awesome \
    fonts-noto-color-emoji \
    xinit \
    curl \
    gpg
echo ""

# --- SCHRITT 3: Brave Browser installieren (via externem Repository) ---
echo ">>> Schritt 3: Brave Browser wird installiert..."

# Hinzufügen des Brave-Repository-Schlüssels
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSLo /etc/apt/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# Hinzufügen des Brave-Repositorys
echo "deb [signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Erneutes Update und Installation von Brave
sudo apt update
sudo apt install -y brave-browser

echo ""
echo ">>> Alle Pakete wurden erfolgreich installiert!"
echo ">>> Bitte befolge die nächsten Schritte, um deine i3-Sitzung zu starten und zu konfigurieren."
