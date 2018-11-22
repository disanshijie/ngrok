### nggork 脚本 
    本目录下自己写的内容
    auto.sh Linux上搭建脚本，只适用与centos

##### 使用
    ```
    wget -N --no-check-certificate https://raw.githubusercontent.com/disanshijie/ngrok/master/sunbo/auto.sh && chmod +x auto.sh && bash auto.sh

    ```
    第二次启动
    ```
    auto.sh 8
    或者自己
    /usr/local/ngrok/bin/ngrokd -domain='wx.sjc.science' -httpAddr=":80" > /dev/null 2>&1

    ```


### 其他
    sunnyos目录是 作者sunnyos写的一个脚本，不好用，仅作为参考


    [2018-11-22]