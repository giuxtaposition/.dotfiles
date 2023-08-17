#!/bin/sh
SCRIPT_DIR_ABS=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
install_file=$SCRIPT_DIR_ABS/pkglist.txt
log_file=$SCRIPT_DIR_ABS/install_progress_log.txt

#==============
# Ask for sudo privileges
#==============
if [ "$EUID" != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

#==============
# Install packages
#==============
packages=()
while IFS= read -r line; do
   packages+=("$line")
done <$install_file

yay -S --noconfirm --needed "${packages[@]}" &> /dev/null

function print_package_status {
  if pacman -Qi $1 > /dev/null; then
    echo "$1 installed" >> $log_file
  else
    echo "$1 failed to install" >> $log_file
  fi
}

for t in ${packages[@]}; do
  print_package_status $t
done

#==============
# Installation Summary
#==============
echo -e "\n====== Summary ======\n"
cat $log_file
echo
rm $log_file
