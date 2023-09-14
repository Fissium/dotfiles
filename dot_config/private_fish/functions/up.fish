function up --wraps='sudo dnf makecache --refresh && sudo dnf upgrade --refresh -y && flatpak update -y' --description 'alias up sudo dnf makecache --refresh && sudo dnf upgrade --refresh -y && flatpak update -y'
  sudo dnf makecache --refresh && sudo dnf upgrade --refresh -y && flatpak update -y $argv
        
end
