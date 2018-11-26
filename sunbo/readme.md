
## TODO http修改，完整步骤 开机启动


### nggork 脚本 
    本目录下自己写的内容
    auto.sh Linux上搭建脚本，只适用与centos

##### 使用

```
    wget -N --no-check-certificate https://raw.githubusercontent.com/disanshijie/ngrok/master/sunbo/ngrok_install.sh && chmod +x ngrok_install.sh && bash ngrok_install.sh
```
    第二次启动
```
    ./ngrok_install.sh
    或者eg:
    /usr/local/ngrok/bin/ngrokd -domain='wx.sjc.science' -httpAddr=":80" > /dev/null 2>&1

```


### 其他
    sunnyos目录是 作者sunnyos写的一个脚本，不好用，仅作为参考


#### 2018-11-23
    强调：关闭防火墙

    关闭防火墙的方法为：
1. 永久性生效
    开启：chkconfig iptables on
    关闭：chkconfig iptables off
2. 即时生效，重启后失效
    开启：service iptables start
    关闭：service iptables stop
3. 防火墙还需要关闭ipv6的防火墙：
    chkconfig ip6tables off
4. 并且可以通过如下命令查看状态：
    chkconfig --list iptables

    执行权限
    chmod +x []