function ss-up --description 'alias shadowsocks up'
    sslocal -c /etc/shadowsocks-rust/config.json -d $argv

end
