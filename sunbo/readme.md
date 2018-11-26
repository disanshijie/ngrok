
## TODO http修改，完整步骤，启动服务， 开机启动


### nggork 脚本 
    本目录下自己写的内容
    auto.sh Linux上搭建脚本，只适用与centos

##### 服务器使用

1. 下载脚本

    ```
    wget -N --no-check-certificate https://raw.githubusercontent.com/disanshijie/ngrok/master/sunbo/ngrok_install.sh && chmod +x ngrok_install.sh && bash ngrok_install.sh
    ```

2. 安装git，go，ngrok（一般就可以了）
    ```
    ./ngrok_install.sh
    1
    报错可以试试2
    ```
3. 运行ngrok
   ```

   ```

4. 下载客户端
    位置
   ```
   /usr/local/ngrok/bin/windows_amd64
   
   ```
5. 客户端配置
    1. 配置文件
    简单eg
    ngrok.cfg
    ```
    server_addr: "wx.sjc.science:4443"
    trust_host_root_certs: false
    ```
    运行：
    客户端目录cmd
    ```
    ngrok -config=ngrok.cfg -subdomain=dfd 80
    ```
    用node开个本地80端口
    浏览器访问 dfd.wx.sjc.science
    --------------------------------------------------


##### 客户端使用


    第二次启动
```
    
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

二. 参数说明：

    ```
    #-domain 访问ngrok是所设置的服务地址生成证书时那个
    #-httpAddr http协议端口 默认为80
    #-httpsAddr https协议端口 默认为443 （可配置https证书）
    #-tunnelAddr 通道端口 默认4443
    ```

三. 域名说明
1. 我的主域名为sjc.science
    域名解析设置中添加
        A记录：wx.sjc.science ip地址：服务器ip
        A记录：*wx.sjc.science ip地址：服务器ip
2. 安装ngrok服务端域名 
    1. 需要输入的域名$NGROK_DOMAIN (wx.sjc.science) ----- 满足解析域名和服务器IP对应，用于证书问题
    2. 运行服务器端ngrokd域名$NGROK_DOMAIN (wx.sjc.science) 一致
    3. 运行客户端ngrok.cfg中server_addr:$NGROK_DOMAIN:$tunnelAddr（server_addr: "wx.sjc.science:4443"）
        1. 强调为$tunnelAddr
        2. $tunnelAddr默认4443，有坑，可以换为443


四. 客户端配置文件
    https://blog.csdn.net/lipc_/article/details/52012642
    client:表示转发http到本机8080，同时要求验证，
    ssh:表示支持远程访问，
    test.yaosansi.com: 绑定了域名转发到9090
    proto: 指定本地地址和端口 （必填）。
    subdomain: 指定二级域名，如果没有配置，ngrok会默认生成一个与隧道节点一样的名字的二级域名。
    auth: 用于在http(s)中身份认证。
    hostname: 指定顶级域名。
    remote_port: 用于在tcp隧道中指定远程服务器端口。
    authtoken: 用于设置登录ngrok的授权码，可以在ngrok首页的dashboard中查看到。
    inspect_addr: 用于设置监听ip，比如设置为 0.0.0.0:8888 意味着监听本机所有ip的 8888 端口上

1. eg
    ngrok.cfg
    ```
    server_addr: "wx.sjc.science:4443"
    trust_host_root_certs: false
    tunnels:
    ddd:
        proto:
        http: "80"
    ssh:
        remote_port: 8022
        proto:
        tcp: "22"

    ```
    启动
    ```
    ngrok -config=ngrok.cfg start ddd
    ```

2. eg
    ngrok.cfg
    ```
    server_addr: "wx.sjc.science:4443"
    trust_host_root_certs: false

    tunnels:
    http:
        subdomain: "www"
        proto:
        http: "8081"
        
    https:
        subdomain: "www"
        proto:
        https: "8082"
        
    web:
        proto:
        http: "8050"
    tcp:
        proto:
        tcp: "8001"
        remote_port: 5555
    
    ssh:
        remote_port: 2222
        proto:
        tcp: "22"
    ```
    启动
    ```
    ngrok -config=ngrok.cfg start web  #启动web服务
    ngrok -config=ngrok.cfg start tcp  #启动tcp服务

    ngrok -config=ngrok.cfg start web tcp  #同时启动两个服务
    ngrok -config=ngrok.cfg start-all  #启动所有服务

    //出现以下内容表示成功链接：
    ngrok

    Tunnel Status                 online
    Version                       1.7/1.7
    Forwarding                    http://web.myngrok.com:8081 -> 127.0.0.1:8050
    Forwarding                    tcp://myngrok.com:5555 -> 127.0.0.1:8001
    Web Interface                 127.0.0.1:4040
    # Conn                        0
    Avg Conn Time                 0.00ms

    ```


3. 附上一个bat，可以部署不同自动启动子域名
    ```
    @echo OFF
    color 0a
    Title ngrok启动
    Mode con cols=109 lines=30
    :START
    ECHO.
    Echo                  ==========================================================================
    ECHO.
    Echo                                         ngrok启动
    ECHO.
    Echo                                         作者: https://segmentfault.com/u/object
    ECHO.
    Echo                  ==========================================================================
    Echo.
    echo.
    echo.
    :TUNNEL
    Echo               输入需要启动的域名前缀，如“test” ，即分配给你的穿透域名为：“test.myngrok.com”
    ECHO.
    ECHO.
    ECHO.
    set /p clientid=   请输入：
    echo.
    ngrok -config=ngrok.cfg -subdomain=%clientid% 80
    PAUSE
    goto TUNNEL

    ```

### 补充记录

    停止服务
    ```
    netstat -tlunp|grep ngrok
    kill [pid]
    ```


参考：
    https://tonybai.com/2015/03/14/selfhost-ngrok-service/