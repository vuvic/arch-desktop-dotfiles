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
