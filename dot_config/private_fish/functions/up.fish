function up --description 'update system packages'
    sudo pacman -Syu && pdm self update

end
