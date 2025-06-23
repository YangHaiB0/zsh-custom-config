# 开启代理
on() {
    export http_proxy="http://127.0.0.1:7897"
    export https_proxy=$http_proxy
    export all_proxy=socks5://127.0.0.1:7897
    success "Clash Verge 代理启动"
}
# 关联代理
off(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    warn "Http 代理关闭"
}

on_hd() {
    export http_proxy="http://192.168.7.131:9803"
    export https_proxy=$http_proxy
    export all_proxy=socks5://192.168.7.131:9803
    success "HengDian(192.168.7.131)代理启动"
}

on_surge() {
    export https_proxy=http://127.0.0.1:6152
    export http_proxy=http://127.0.0.1:6152
    export all_proxy=socks5://127.0.0.1:6153
    success "Surge 代理启动"
}