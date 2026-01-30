
# Enable multilib if disabled
if grep -q '^\[multilib\]' /etc/pacman.conf; then
  echo "multilib already enabled"
else
  echo "Enabling multilib..."
  sudo sed -i '/^\#\[multilib\]/,/^$/ { s/^\#// }' /etc/pacman.conf
  sudo pacman -Sy
fi

# Enable extra if disabled
if grep -q '^\[extra\]' /etc/pacman.conf; then
  echo "extra already enabled"
else
  echo "Enabling extra..."
  sudo sed -i '/^\#\[extra\]/,/^$/ { s/^\#// }' /etc/pacman.conf
  sudo pacman -Sy
fi

# Install packages from list

input="$HOME/dotfiles/packages/pkg-list.txt"
 
sudo pacman -S --needed - < $input


