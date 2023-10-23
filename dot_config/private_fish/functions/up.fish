function up --description 'update packages'
    sudo dnf makecache --refresh && sudo dnf upgrade --refresh -y && flatpak update -y && chezmoi upgrade && pdm self update $argv

end
