function up --description 'update the system'
  
  echo (set_color yellow) "Updating packages..."(set_color normal)
  sudo pacman -Syu
  sleep 1
  echo (set_color yellow) "Done"(set_color normal)
  echo (set_color yellow) "Updating mamba..."(set_color normal)
  mamba self-update && mamba clean --all
  sleep 1
  echo (set_color yellow) "Done"(set_color normal)
  echo (set_color yellow) "Updating rustup..."(set_color normal)
  rustup self update && rustup update
  sleep 1
  echo (set_color yellow) "Done"(set_color normal)
  echo (set_color yellow) "Removing rust-analyzer from $CARGO_HOME/bin..."(set_color normal)
  rm -rf "$CARGO_HOME/bin/rust-analyzer"
  sleep 1
  echo (set_color yellow) "Done"(set_color normal)
    
end
