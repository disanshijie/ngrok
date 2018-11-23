#!/bin/bash

#http://blog.51cto.com/12173069/2120166
# 没做完

basepath='/home/lee/ngrok'

ngrok_auto() {
    config_runshell_ngrok

    #启用服务：
    systemctl  enable  ngrok
    # 添加开机自启动：
    chkconfig  ngrok  on

    #启动服务
    #systemctl  start  ngrok

}

config_runshell_ngrok() {

#编写运行脚本
#创建脚本目录
mkdir -p $basepath
#创建日志文件
mkdir -p /var/log/ngrok
touch /var/log/ngrok/ngrok.log
#vim /home/lee/ngrok/ngrok.sh
cat > ${basepath}/ngrok.sh <<EOF
#!/bin/bash
# -------------config START-------------
/usr/local/ngrok/bin/ngrokd -log="/var/log/ngrok/ngrok.log" -domain="dollarphp.com" 1> /dev/null 2> /var/log/ngrok/ngrok.log &
echo $! > /var/run/ngrok.pid
# -------------config END-------------
EOF

#创建启动服务
#vim /usr/lib/systemd/system/ngrok.service
cat > /usr/lib/systemd/system/ngrok.service <<EOF
# -------------config START-------------
[Unit]  
Description=ngrok
After=network.target 
[Service]  
Type=forking  
PIDFile=/var/run/ngrok.pid
ExecStart=/bin/bash  ${basepath}/ngrok.sh
ExecStop=pkill  ngrok
PrivateTmp=true  
[Install]  
WantedBy=multi-user.target 
# -------------config END-------------
EOF
}


}