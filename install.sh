#/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cd /usr/local/
if [[ -e /usr/local/caddy/ ]]; then
        rm /usr/local/caddy/ -rf
fi
wget -N --no-check-certificate -O /usr/local/caddy2-naive-linux-arm64.tar.gz https://gitlab.com/rwkgyg/naiveproxy-yg/-/raw/main/caddy2-naive-linux-arm64.tar.gz
if [[ $? -ne 0 ]]; then
  echo -e "${red}下载失败，请确保你的服务器正常${plain}"
  exit 1
fi
mkdir caddy
tar -C /usr/local/caddy -zxf /usr/local/caddy2-naive-linux-arm64.tar.gz
rm caddy2-naive-linux-arm64.tar.gz -f
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
cd caddy
echo -e "{\n\torder forward_proxy before file_server\n}" >> Caddyfile
echo -e ":${config_port}, ${config_domain} {" >> Caddyfile
echo -e "\ttls ${config_cert} ${config_key}" >> Caddyfile
echo -e "\tforward_proxy {" >> Caddyfile
echo -e "\t\tbasic_auth ${config_user} ${config_pass}" >> Caddyfile
echo -e "\t\thide_ip" >> Caddyfile
echo -e "\t\thide_via" >> Caddyfile
echo -e "\t\tprobe_resistance" >> Caddyfile
echo -e "\t}" >> Caddyfile
echo -e "\treverse_proxy https://${config_fake} {" >> Caddyfile
echo -e "\t\theader_up  Host  { upstream_hostport }" >> Caddyfile
echo -e "\t\theader_up  X-Forwarded-Host  { host }" >> Caddyfile
echo -e "\t}" >> Caddyfile
echo -e "}" >> Caddyfile
touch /var/log/caddy/caddy.log
touch caddy.env
wget -N --no-check-certificate -O /etc/systemd/system/caddy.service https://raw.githubusercontent.com/yesli/naive_installer/main/caddy.service
if [[ $? -ne 0 ]]; then
  echo -e "${red}caddy.service下载失败！${plain}"
  exit 1
fi
systemctl daemon-reload
systemctl enable caddy
echo -e "${green}安装完成！${plain}"
