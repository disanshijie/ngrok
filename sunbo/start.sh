#!/bin/bash

#设置后台启动

domain='wx.sjc.science'
httpAddr=80
cmd=`/usr/local/ngrok/bin/ngrokd -domain=$domain -httpAddr=":$httpAddr"`


# 安装screen
install_screen(){
	yum install -y screen
}
ngrok_start() {
    screen -S keepNgrok $cmd
    #需继续按 CTRL +a+d
}
ngrok_stop() {
    screen -r keepNgrok
    exit 0
    #终端用 CTRL+c就行
}

ngrok_start

