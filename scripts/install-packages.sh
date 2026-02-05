SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR"/lib/enable-pacman-repo.sh
source "$SCRIPT_DIR"/lib/install-yay.sh

# Enable multilib and extra repositories
for repo in multilib extra; do
  enable_pacman_repo "$repo"
done

# Install packages from list
pkg_list="$HOME/dotfiles/packages/pkg-list.txt" 
echo "Fetching files from $pkg_list..."
sudo pacman -S --needed --noconfirm - < "$pkg_list"

# Install AUR packages if pkg-list-aur.txt exists and has at least 1 item
aur_list="$HOME/dotfiles/packages/pkg-list-aur.txt"
if [[ -f "$aur_list" && -s "$aur_list" ]]; then
  install_yay
  echo "Installing AUR packages from $aur_list..."
  yay -S --needed --noconfirm - < "$aur_list"
fi
