#/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

wget -P ~ https://gitlab.com/rwkgyg/naiveproxy-yg/-/raw/main/caddy2-naive-linux-arm64.tar.gz
rm -r ~/caddy
tar -C ~/caddy -zxf ~/caddy2-naive-linux-arm64.tar.gz
read -p "请设置您的域名:" config_domain
echo -e "${yellow}您的域名将设定为:${config_domain}${plain}"
read -p "请设置您的监听端口:" config_port
echo -e "${yellow}您的监听端口将设定为:${config_port}${plain}"
read -p "请设置公钥地址:" config_cert
echo -e "${yellow}您的公钥地址为:${config_cert}${plain}"
read -p "请设置私钥地址:" config_key
echo -e "${yellow}您的私钥地址为:${config_key}${plain}"
read -p "请设置用户名:" config_user
echo -e "${yellow}您的用户名为:${config_user}${plain}"
read -p "请设置密码:" config_pass
echo -e "${yellow}您的密码为:${config_pass}${plain}"
read -p "请设置伪装网站（不带http/https):" config_fake
echo -e "${yellow}伪装网站为:${config_fake}${plain}"
echo -e "${green}正在生成配置文件！${plain}"
echo -e "{\n\torder forward_proxy before file_server\n}" >> ~/caddy/Caddyfile
echo -e ":${config_port}, ${config_domain} {" >> ~/caddy/Caddyfile
echo -e "\ttls ${config_cert} ${config_key}" >> ~/caddy/Caddyfile
echo -e "\tforward_proxy {" >> ~/caddy/Caddyfile
echo -e "\t\tbasic_auth ${config_user} ${config_pass}" >> ~/caddy/Caddyfile
echo -e "\t\thide_ip" >> ~/caddy/Caddyfile
echo -e "\t\thide_via" >> ~/caddy/Caddyfile
echo -e "\t\tprobe_resistance" >> ~/caddy/Caddyfile
echo -e "\t}" >> ~/caddy/Caddyfile
echo -e "\treverse_proxy https://${config_fake} {" >> ~/caddy/Caddyfile
echo -e "\t\theader_up  Host  { upstream_hostport }" >> ~/caddy/Caddyfile
echo -e "\t\theader_up  X-Forwarded-Host  { host }" >> ~/caddy/Caddyfile
echo -e "\t}" >> ~/caddy/Caddyfile
echo -e "}" >> ~/caddy/Caddyfile
