function pdm-activate --description 'Use pdm to activate an env'
    eval (pdm venv activate $argv)
end
