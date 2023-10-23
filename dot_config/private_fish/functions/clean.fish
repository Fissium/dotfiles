function clean --description="clean system"
    sudo dnf autoremove -y && \ 
    dnf clean all && flatpak uninstall --unused -y && sudo journalctl --rotate --vacuum-size=100M && sh /home/fissium/tools/custom_sh/flatfolder.sh $argv

end
