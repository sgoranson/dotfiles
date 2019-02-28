alias pac-list-with-desc="expac -Q  '%-30n\t%w\t%d'"

# alias pac-update-all="pacaur --noconfirm -Syu"
# alias pac-list-aur-pkgs="pacaur -Qm | awk '{print \$1}'"
# alias pac-list-manual-pkgs="pacman -Qe | awk '{print \$1}'"

alias pac-base-pkgs="pacman -Qqg base base-devel xorg xorg-apps xorg-drivers xorg-fonts i3"
alias pac-all-pkgs-in-repo="pacman -Slq | sort"
alias pac-all-pkgs-in-local="pacman -Qq | sort"
alias pac-group-list="pacman -Sgg"
alias pac-changed-etc-files="sudo pacman -Qii | awk '/^MODIFIED/ {print $2}'"

alias pac-keyring-fix="sudo pacman-key --init && sudo pacman-key --populate && sudo pacman-key --refresh-keys && sudo pacman -Sy archlinux-keyring"
alias pac-mirror-update='sudo reflector --verbose -n 10 -c US --sort rate --save /etc/pacman.d/mirrorlist'
