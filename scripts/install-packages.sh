function enable_pacman_repo ()
{
  local repo="$1"
  local conf="/etc/pacman.conf"

  # Check if a second parameter was passed
  if [[ -z "$repo" ]]; then
    echo "Usage: enable_pacman_repo <repo-name>"
    return 1
  fi

  # Check if repo is already enabled
  if grep -q "^\[$repo\]" "$conf"; then
    echo "$repo already enabled"
    return 0
  fi
  
  # Enable repo if it is found disabled in the config file
  if grep -q "^#\[$repo\]" "$conf"; then
    echo "Enabling $repo"
    sudo sed -i "/^#\[$repo\]/,/^$/ { s/^\#// }" "$conf"
    sudo pacman -Sy
  else   
    echo "Repo '$repo' not found in $conf"
    return 1
  fi
}

# Installs yay - a pacman helper for AUR packages
install_yay() {
  # "If the command "yay" works"
  # Also send the output - either file descriptor 1 (stdout) to /dev/null (discards anything written to it)
  # or file descriptor 2 (sterr) where file descriptor 1 would otherwise go; &indicates that what follows 
  # is a file descriptor, not a filename
  if command -v yay >/dev/null 2>&1; then
    echo "yay already installed"
    return 0
  fi

  echo "Installing yay..."

  sudo pacman -S --needed --noconfirm base-devel git

  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)

  rm -rf "$tmpdir"
}


# Enable multilib and extra repositories
for repo in multilib extra; do
  enable_pacman_repo "$repo"
done


# Install packages from list
pkg_list="$HOME/dotfiles/packages/pkg-list.txt" 
echo "Fetching files from $pkg_list..."
sudo pacman -S --needed - < "$pkg_list"

# Install AUR packages if pkg-list-aur.txt exists and has at least 1 item
aur_list="$HOME/dotfiles/packages/pkg-list-aur.txt"
if [[ -f "$aur_list" && -s "$aur_list" ]]; then
  install_yay
  echo "Installing AUR packages from $aur_list..."
  yay -S --needed - < "$aur_list"
fi
