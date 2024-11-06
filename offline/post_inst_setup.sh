#!/bin/bash
echo "This script is to be made to install relevant python packages for user, configure system settings and to setup docker."

#############Configure python and venv#############
sudo apt-get install python3-full
python3 -m venv ~/general_venv # Create a general venv
# Add an alias so calling 'venv' in the terminal activates the general venv
ALIAS_COMMAND="alias venv='source ~/general_venv/bin/activate'" 
if grep -Fxq "$ALIAS_COMMAND" ~/.bashrc
then
    echo "Alias for venv already exists in ~/.bashrc"
else
    echo "$ALIAS_COMMAND" >> ~/.bashrc
    echo "Alias for venv added to ~/.bashrc"
fi
source ~/.bashrc # Apply changes
~/general_venv/bin/pip install boto3 pandas awscli tk tkcalendar sshtunnel jupyter plotly scipy papermill opencv-python # Install some good packages to the new venv
##########################################


#############Configure appearance settings############
#screensaver
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1VlWqlvpvqa4-v5yf97peIMZV0FHENbmr' -O ~/Downloads/saver.jpg
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Downloads/saver.jpg"

#desktop dock settings
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock panel-mode false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 60
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox_firefox.desktop', 'slack_slack.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'postman_postman.desktop', 'keepassxc_keepassxc.desktop', 'snap-store_snap-store.desktop', 'org.gnome.Settings.desktop']"


#vlc as default video player
for type in video/x-msvideo video/mp4 video/mpeg video/x-matroska video/quicktime video/x-ms-wmv video/x-flv video/webm video/ogg video/x-m4v; do
  xdg-mime default vlc.desktop $type
done

#vscode as default for relevant file extensions
fpr type in text/x-python application/json text/html text/plain
  xdg-mime default code.desktop $type
done

#Setup docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Post-installation setup
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin https://594162119682.dkr.ecr.eu-west-1.amazonaws.com
