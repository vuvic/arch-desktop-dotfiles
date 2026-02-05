  GNU nano 8.7.1                                                      install-packages.sh                                                                 
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
