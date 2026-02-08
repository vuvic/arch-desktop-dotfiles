# This file is read at by the login shell at the beginning of a login
# session.

# If the directory $home/.local/bin exists, the && clause executes,
# appending the directory to the $PATH variable

[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
