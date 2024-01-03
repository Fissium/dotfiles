function up --description 'update the system'
  
  echo "Updating packages..."
  sudo pacman -Syu
  sleep 1
  echo "Done"
  sleep 1
  echo "Updating rustup and mamba..."
  mamba self-update && mamba clean --all
  sleep 1
  rustup self update && rustup update
  echo "Done"
  sleep 1
  echo "Removing rust-analyzer from $CARGO_HOME/bin..."
  rm -rf "$CARGO_HOME/bin/rust-analyzer"
  echo "Done"
    
end
