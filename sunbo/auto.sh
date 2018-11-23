#!/bin/bash
# -*- coding: UTF-8 -*-
#############################################
#作者 sunbo
#只能 centos

#############################################
# 获取当前脚本执行路径
SELFPATH=$(cd "$(dirname "$0")"; pwd)
GOOS=`go env | grep GOOS | awk -F\" '{print $2}'`
GOARCH=`go env | grep GOARCH | awk -F\" '{print $2}'`
#ngrok安装目录
NGROKPATH='/usr/local/ngrok'

echo `系统：$GOOS,版本：$GOARCH`

install_yilai(){
	yum -y install zlib-devel openssl-devel perl hg cpio expat-devel gettext-devel curl curl-devel perl-ExtUtils-MakeMaker hg wget gcc gcc-c++ unzip
}

# 安装git
install_git(){
	yum install -y git
}

# 安装go
install_go(){
	yum install -y golang
}
# 卸载go
uninstall_go(){
	yum uninstall golang
}
# 安装screen
install_screen(){
	yum install -y screen
}
# 卸载screen
uninstall_screen(){
	yum uninstall screen
}


# 安装ngrok
install_ngrok(){

	uninstall_ngrok
    git clone https://github.com/inconshreveable/ngrok.git /usr/local/ngrok

    echo '请输入一个域名'
    read DOMAIN
#	export GOPATH=/usr/local/ngrok/
	export NGROK_DOMAIN=$DOMAIN
	cd $NGROKPATH
	openssl genrsa -out rootCA.key 2048
	openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out rootCA.pem
	openssl genrsa -out server.key 2048
	openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
	openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000
	cp rootCA.pem assets/client/tls/ngrokroot.crt
	cp server.crt assets/server/tls/snakeoil.crt
	cp server.key assets/server/tls/snakeoil.key
	# 编译不同平台的服务端
	cd $NGROKPATH
	GOOS=$GOOS GOARCH=$GOARCH make release-server
    #启动
	#wget -N --no-check-certificate https://raw.githubusercontent.com/disanshijie/ngrok/master/sunbo/start.sh
	#chmod +x $NGROKPATH/sunbo/start.sh
	#/usr/local/ngrok/bin/ngrokd -domain=$NGROK_DOMAIN -httpAddr=":80"
}
# 卸载ngrok
uninstall_ngrok(){
	rm -rf $NGROKPATH
}

# 编译客户端
compile_client(){
	cd $NGROKPATH
	GOOS=$1 GOARCH=$2 make release-client
}

# 生成客户端
client(){
	echo "1、Linux 32位"
	echo "2、Linux 64位"
	echo "3、Windows 32位"
	echo "4、Windows 64位"
	echo "5、Mac OS 32位"
	echo "6、Mac OS 64位"
	echo "7、Linux ARM"

	read num
	case "$num" in
		[1] )
			compile_client linux 386
		;;
		[2] )
			compile_client linux amd64
		;;
		[3] )
			compile_client windows 386
		;;
		[4] ) 
			compile_client windows amd64
		;;
		[5] ) 
			compile_client darwin 386
		;;
		[6] ) 
			compile_client darwin amd64
		;;
		[7] ) 
			compile_client linux arm
		;;
		*) echo "选择错误，退出";;
	esac

}


echo "请输入下面数字进行选择"
echo "#############################################"
echo "#作者sunbo"
echo "#############################################"
echo "------------------------"
echo "1、全新安装"
echo "2、安装依赖"
echo "3、安装git"
echo "4、安装go环境"
echo "5、安装ngrok"
echo "6、生成客户端"
echo "7、卸载"
echo "8、启动服务"
echo "9、查看配置文件"
echo "------------------------"
read num
case "$num" in
	[1] )
		install_yilai
		install_git
		install_go
		install_screen
		install_ngrok
	;;
	[2] )
		install_yilai
	;;
	[3] )
		install_git
	;;
	[4] )
		install_go
	;;
	[5] )
		install_ngrok
	;;
	[6] )
		client
	;;
	[7] )
		uninstall_go
		uninstall_ngrok
	;;
	[8] )
		echo "输入启动域名"
		read domain
		echo "启动端口"
		read port
		/usr/local/ngrok/bin/ngrokd -domain=$domain -httpAddr=":$port" > /dev/null 2>&1
	;;
	[9] )
		echo "输入启动域名"
		read domain
		echo server_addr: '"'$domain:4443'"'
		echo "trust_host_root_certs: false"

	;;
	*) echo "";;
esac
