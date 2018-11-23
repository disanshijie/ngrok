#!/bin/bash

domain='wx.sjc.science'
port='0'
httpAddr=80
httpsAddr=443
tunnelAddr=4443

#启动服务
ngrok_start() {
    if [ ! -d /var/log/ngrok ]; then
        mkdir -p /var/log/ngrok
        touch /var/log/ngrok/ngrok.log
    fi
    if [ ! -f /var/log/ngrok/ngrok.log ]; then
       touch /var/log/ngrok/ngrok.log
    fi
    echo "-----"$port"-----"


    if [[ $port -eq '0' ]]; then
        #默认httpsAddr443，tunnelAddr4443
        echo "默认：80 443 4443"
        /usr/local/ngrok/bin/ngrokd -domain=$domain -log="/var/log/ngrok/ngrok.log" 1> /dev/null 2> /var/log/ngrok/ngrok.log &
        #echo $! > /var/run/ngrok.pid
    else
        #自定义
        echo "自定义：80 443 4443"
       # cmd=`/usr/local/ngrok/bin/ngrokd -domain=$domain -httpAddr=":$httpAddr" -httpsAddr=":$httpsAddr" -tunnelAddr=":$tunnelAddr"`
        #cmd2=`/usr/local/ngrok/bin/ngrokd -domain=$domain -httpAddr=":$httpAddr" -httpsAddr=":5555" -tunnelAddr=":555"`
       # $cmd -log="/var/log/ngrok/ngrok.log" 1> /dev/null 2> /var/log/ngrok/ngrok.log &
        /usr/local/ngrok/bin/ngrokd -domain=$domain -httpAddr=":$httpAddr" -httpsAddr=":$httpsAddr" -tunnelAddr=":$tunnelAddr" -log="/var/log/ngrok/ngrok.log" 1> /dev/null 2> /var/log/ngrok/ngrok.log &
        
        echo $! > /var/run/ngrok.pid
        #需继续按 CTRL +a+d
    fi

    #/usr/local/ngrok/bin/ngrokd -log="/var/log/ngrok/ngrok.log" -domain=$domain -httpAddr=":80" -httpsAddr=":5555" -tunnelAddr=":555" 1> /dev/null 2> /var/log/ngrok/ngrok.log & 
    #echo $! > /var/run/ngrok.pid
}

#用screen实现
ngrok_start2() {
    #执行
    if [[ `yum list installed | grep screen |wc -l` -eq 0 ]];then
        yum install -y screen
    fi
    screen -S keepNgrok /usr/local/ngrok/bin/ngrokd -domain=$domain -httpAddr=":$httpAddr" -httpsAddr=":$httpsAddr" -tunnelAddr=":$tunnelAddr"
    #需继续按 CTRL +a+d
    
    #结束运行
    #screen -r keepNgrok
    #exit 0
    #终端用 CTRL+c就行
}

while [ $# -gt 0 ]; do
    case $1 in
        -d|--domain)
			if [[ -n $2 ]]; then
            	domain=$2
			fi
            shift 2
            ;;
		#端口
        -p|--port)
			if [[ -n $2 ]]; then
                httpAddr=$2
                httpsAddr=$3
                tunnelAddr=$4
            	port='1'
			fi
            shift 4
            ;;
        -v|--verbose)
            verbose="1"
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal Error: option processing error: $1" 1>&2
            exit 1
            ;;
    esac
done


if [[ $verbose -eq '1' ]]; then
    ngrok_start2
else
    ngrok_start
fi

###################################################
#执行ngrok_start
#/root/ngrok/ngrok_start.sh
#/root/ngrok/ngrok_start.sh -d wx.sjc.science
#/root/ngrok/ngrok_start.sh -p 80 443 4443
#执行ngrok_start2
#/root/ngrok/ngrok_start.sh -p 80 443 4443 -v