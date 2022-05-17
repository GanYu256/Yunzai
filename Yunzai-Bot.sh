#!/bin/bash
# 适用于 Termux ubuntu-18.04 bionic
# 适用于 Linux deploy ubuntu-18.04 bionic
# 适用于其他 ARM64平台 ubuntu-18.04 LTS 系统
# 2022年5月17日01:31:26

function menu()													#显示菜单
{
    cat <<eof 
    
 **********************************************************************
                 Yunzai-Bot安装程序(arm64)                 

           1.获取平台架构            2.开始自动安装
             
           3.安装喵喵插件            4.安装黄历插件
             
           5.安装ffmpeg              6.清理安装文件

           7.启动Yunzai              0.退出安装程序

1.本程序会自动部署Yunzai-Bot，可选安装喵喵、ffmpeg以及黄历插件
2.本程序仅适合aarch64(arm64)操作平台的 ubuntu-18.04 LTS 系统
3.请确认你的操作平台是aarch64(arm64)
4.x86(amd64) armhf(arm32)会安装失败，导致apt无法安装软件
5.请确认你的设备符合要求，否则本人概不负责！！！
6.ffmpeg安装测试成功后，可以选择"6"来清理ffmpeg的安装文件
7..由于没有x86平台，无法编辑测试脚本可行性！暂仅支持arm64
8.碰到选项怎么选? 全部点回车就行了！

适用于 Termux ubuntu-18.04 bionic LTS 系统
适用于 Linux deploy ubuntu-18.04 bionic LTS 系统
适用于其他 ARM64平台 ubuntu-18.04 bionic LTS 系统
本安装程序由2430248074 编辑于2022-05-18 16:26:38
 **********************************************************************
eof
}
function num()													#选项
{
    read -p "请输入您需要操作的项目: " number
    case $number in
        1)
            arch
            ;;
        2)
            install
            ;;
        3)
            miao
            ;;
        4)
            huangli
            ;;
        5)
            ffmpeg
            ;;
        6)
            qingli
            ;;
        7)
            start
            ;;
        0)
            exit 0
            ;;

    esac
}
function arch()
{
        echo
        echo '平台架构'
        uname -m
        exit
}

function install()
{
        #更换清华源以提升拉取速度
        echo '更换清华源以提升拉取速度';
        echo -e "\ndeb https://mirrors.ustc.edu.cn/ubuntu-ports/ bionic main restricted universe multiverse
        deb https://mirrors.ustc.edu.cn/ubuntu-ports/ bionic-updates main restricted universe multiverse
        deb https://mirrors.ustc.edu.cn/ubuntu-ports/ bionic-backports main restricted universe multiverse
        deb https://mirrors.ustc.edu.cn/ubuntu-ports/ bionic-security main restricted universe multiverse" > /etc/apt/sources.list
        echo '添加完成'；
        echo '更新软件'；
        apt update
        apt upgrade -y
        echo '更新成功'；
        echo

        #安装python3.8 pip3 wget git curl
        echo '安装python3.8 python3-pip wget git curl';
        apt-get install python3.8 python3-pip wget git curl -y
        echo 'python3.8 python3-pip wget git curl安装完成'
        echo

        # 安装nodejs
        echo '安装nodejs开始';
        if ! type node >/dev/null 2>&1; then
          curl -sL https://deb.nodesource.com/setup_16.x | bash -
          apt-get install -y nodejs
        else
          echo 'nodejs已安装';
        fi
        echo '安装nodejs完成';
        echo

        # 安装并运行redis
        echo '安装redis开始';
        apt-get install redis -y
        redis-server --daemonize yes
        echo '安装redis完成';
        echo

        # 安装chromium
        echo '安装chromium开始';
        apt install chromium-browser -y
        echo '安装chromium完成';
        echo

        # 安装中文字体
        echo '安装中文字体开始';
        apt install -y --force-yes --no-install-recommends fonts-wqy-microhei
        echo '安装中文字体完成';
        echo

        #拉取pip3.8升级程序
        echo '拉取pip3.8升级程序';
        echo '从外网下载速度比较慢，请耐心等待...'
        if [ ! -f "/tmp/get-pip.py" ];then
          wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
          if [ ! -f "/tmp/get-pip.py" ];then
            echo "下载失败"
            exit 0
          else
            echo '下载完成'
          fi
        else
          echo '下载完成'
        fi
        echo

        #安装pip3.8
        echo '开始升级pip3.8';
        python3.8 /tmp/get-pip.py
        echo 'pip3.8升级完成';
        echo

        #设置默认python3.8 pip3.8
        echo '设置python3.8 pip3.8为默认';
        echo '删除python';
        rm /usr/bin/python
        echo '删除pip';
        rm /usr/bin/pip
        echo 'python3.8链接到python';
        ln -s /usr/bin/python3.8 /usr/bin/python
        echo 'pip3.8链接到pip';
        ln -s /usr/bin/pip3.8 /usr/bin/pip
        echo '设置完毕';
        echo

        # 克隆项目
        echo '克隆Yunzai-Bot开始';
        cd ~/
        if [ ! -d "Yunzai-Bot/" ];then
          git clone https://gitee.com/Le-niao/Yunzai-Bot.git
          if [ ! -d "Yunzai-Bot/" ];then
            echo "克隆失败"
            exit 0
          else
            echo '克隆完成'
          fi
        else
          echo '克隆完成'
        fi
        echo

        #安装bot模块
        echo '安装bot模块'
        cd Yunzai-Bot
        echo '安装模块开始';
        if [ ! -d "node_modules/" ];then
          npm install
          echo '安装模块完成'
        else
          echo '安装模块完成'
        fi

        echo 'bot模块安装成功';
        echo
}

function miao()
{
        # 克隆喵喵项目
        echo '克隆喵喵插件开始';
        cd ~/Yunzai-Bot
        if [ ! -d "plugins/miao-plugin/" ];then
          git clone https://gitee.com/yoimiya-kokomi/miao-plugin.git ./plugins/miao-plugin/
          if [ ! -d "plugins/miao-plugin/" ];then
            echo "喵喵克隆失败"
            exit 0
          else
            echo '喵喵克隆完成'
          fi
        else
          echo '喵喵克隆完成'
        fi
        echo

        #安装喵喵模块
        echo '安装喵喵模块开始';
        if [ ! -d "node_modules/moment/" ];then
          npm install moment
          echo '安装喵喵模块完成'
        else
          echo '安装喵喵模块完成'
        fi

        echo '喵喵模块安装成功';
        echo
}
function huangli()
{
        # 克隆黄历项目
        echo '克隆黄历插件';
        cd ~/Yunzai-Bot
        if [ ! -d "plugins/python-plugin/" ];then
          git clone https://gitee.com/linglinglingling-python/python-plugin.git ./plugins/python-plugin/
          if [ ! -d "plugins/python-plugin/" ];then
            echo "黄历克隆失败"
            exit 0
          else
            echo '黄历克隆完成'
          fi
        else
          echo '黄历克隆完成'
        fi
        echo

        #安装黄历模块
        echo '安装黄历模块开始';
        if [ ! -d "node_modules/pm2/" -a -d "node_modules/node-schedule/" ];then
          npm install pm2 -g
          npm install node-schedule
            echo "安装黄历模块成功"
          else
            echo '安装黄历模块成功'
          fi
        echo

        pip install pillow loguru pytz python-dateutil requests httpx -i https://pypi.tuna.tsinghua.edu.cn/simple/
        cd ~/Yunzai-Bot/plugins/python-plugin/
        pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ -r requirement.txt
        echo '安装模块完成'
        echo '这里报错请无视，使用"#黄历"命令不报错就行了';
        rm /tmp/get-pip.py
        echo '黄历安装成功'
}
function ffmpeg()
{
        #arm64架构 ubuntu-18.04 LTS自动配置Yunzai-Bot音频转码“ffmpeg相关依赖”
        #由于ffmpeg从Git拉取，众所周知Git网速极其稳定（bushi）。如果出现拉取特别慢，请睡一觉(bushi)
        echo 部署系统编译环境：
        apt install -y automake autoconf libtool gcc gcc- git wget curl
        if [ $? -ne 0 ]; then
            echo "失败了！"
        else
            echo "编译环境配置成功！"
        fi
        echo
        echo '创建目录'
        mkdir ~/ffmpeg
        mkdir ~/ffmpeg/res
        mkdir ~/ffmpeg/tmp
        chmod -R 777 ~/ffmpeg
        echo
        echo 下载所需资源中！
        echo ffmpeg从git拉取，速度不稳定！耐心等待...
        cd ~/ffmpeg/res
        git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg
        if [ $? -ne 0 ]; then
            echo "ffmpeg拉取失败！请检查网络！"
        else
            echo "ffmpeg下载成功！"
        fi
        wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
        if [ $? -ne 0 ]; then
            echo "yams拉取失败！请检查网络！"
        else
            echo "yams下载成功！"
        fi
        wget http://jaist.dl.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
        if [ $? -ne 0 ]; then
            echo "lame拉取失败！请检查网络！"
        else
            echo "lame下载成功！"
        fi
        wget http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.3.tar.gz
        if [ $? -ne 0 ]; then
            echo "amr拉取失败！请检查网络！"
        else
            echo "amr下载成功！"
        fi
        wget http://www.penguin.cz/~utx/ftp/amr/amrnb-11.0.0.0.tar.bz2
        if [ $? -ne 0 ]; then
            echo "amrnb拉取失败！请检查网络！"
        else
            echo "amrnb下载成功！"
        fi
        wget http://www.penguin.cz/~utx/ftp/amr/amrnb-11.0.0.0.tar.bz2wget http://www.penguin.cz/~utx/ftp/amr/amrwb-11.0.0.0.tar.bz2
        if [ $? -ne 0 ]; then
            echo "amrwb拉取失败！请检查网络！"
        else
            echo "amrwb下载成功！"
        fi
        cd ~/ffmpeg
        echo 资源加载完成，可以开始安装！

        echo 开始自动安装
        echo
        mkdir ./tmp
        chmod -R 777 ./*
        cd ./tmp
        echo '安装yasm'
        tar -xzvf ../res/yasm-1.3.0.tar.gz
        chmod -R 777 ./yasm-1.3.0
        cd yasm-1.3.0
        echo 配置yasm源码
        ./configure -build=arm-linux
        echo 编译yasm源码
        make
        echo 安装yasm
        make install
        cd ../
        echo

        echo '安装lame'
        tar -xzvf ../res/lame-3.99.5.tar.gz 
        chmod -R 777 ./lame-3.99.5
        cd lame-3.99.5
        echo 配置lame源码
        ./configure -build=arm-linux
        echo 编译lame源码
        make
        echo 安装lame
        make install
        cd ../
        echo

        echo '安装opencore-amr'
        tar -xzvf ../res/opencore-amr-0.1.3.tar.gz 
        chmod -R 777 ./opencore-amr-0.1.3
        cd opencore-amr-0.1.3
        echo 配置amr源码
        ./configure
        echo 编译amr源码
        make
        echo 安装amr
        make install
        cd ../
        echo

        echo '安装amrnb'
        tar -xjvf ../res/amrnb-11.0.0.0.tar.bz2 
        chmod -R 777 ./amrnb-11.0.0.0
        cd amrnb-11.0.0.0
        echo 配置amrnb源码
        ./configure
        echo 编译amrnb源码
        make
        echo 安装amrnb
        make install
        cd ../
        echo

        echo '安装amrwb'
        tar -xjvf ../res/amrwb-11.0.0.0.tar.bz2 
        chmod -R 777 ./amrwb-11.0.0.0
        cd amrwb-11.0.0.0
        echo 配置amrwb源码
        ./configure
        echo 编译amrwb源码
        make
        echo 安装amrwb
        make install
        cd ../
        echo 
        echo '安装ffmpeg'
        tar -xjvf ../res/ffmpeg.tar.bz2 
        chmod -R 777 ./ffmpeg
        cd ffmpeg
        echo 配置ffmpeg源码
        ./configure --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-version3 --enable-shared
        echo 编译ffmpeg源码
        make
        echo 安装ffmpeg
        make install
        echo "/usr/local/lib" >> /etc/ld.so.conf
        echo "/usr/local/lib64" >> /etc/ld.so.conf
        ldconfig
        cd ../
        cd ../
        echo 清理安装文件
        rm -rf ./tmp/*
        echo 部署完毕！
        echo

        echo 你可以前往机器人进行测试！
        echo 脚本编辑于2022-5-17 16:00
        echo 编辑者QQ：2430248074 
        echo 感谢CNDS用户 @张近微：https://blog.csdn.net/weixin_32563347/article/details/116680608
        echo 感谢CNDS用户 @weixin_39807691 : https://blog.csdn.net/weixin_39807691/article/details/116910741
        echo      ▬▬.◙.▬▬
        echo    ▂▄▄▓▄▄▂
        echo ◢◤ █▀▀████▄▄▄▄▄◢◤
        echo ██再见████▀▀▀▀╬
        echo     ◥███████◤
        echo     ══╩══╩══我走了，我不打扰！

}

function qingli()
{
        rm -rf ~/ffmpeg
        exit
}

function start()
{
        cd ~/Yunzai-Bot
        node app
}

function  main()
{
    while true
    do
        menu
        num
    done
}
main    #循环菜单跟选项
