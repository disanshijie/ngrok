#!/bin/bash

#设置后台启动

domain='wx.sjc.science'
httpAddr=80

ngrok_start() {
    screen -S keepNgrok
    sudo /usr/local/ngrok/bin/ngrokd -domain=$domain -httpAddr=":$httpAddr"
}

ngrok_stop() {
    screen -S keepNgrok

}

ngrok_start

