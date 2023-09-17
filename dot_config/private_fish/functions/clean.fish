function clean --wraps='sudo dnf autoremove -y && dnf clean all && flatpak uninstall --unused -y && sudo journalctl --vacuum-time=2weeks && sh /home/fissium/tools/custom_sh/flatfolder.sh' --description 'alias clean sudo dnf autoremove -y && dnf clean all && flatpak uninstall --unused -y && sudo journalctl --vacuum-time=2weeks && sh /home/fissium/tools/custom_sh/flatfolder.sh'
  sudo dnf autoremove -y && dnf clean all && flatpak uninstall --unused -y && sudo journalctl --rotate --vacuum-size=100M && sh /home/fissium/tools/custom_sh/flatfolder.sh $argv
        
end
