#!/bin/bash
# 适用于 Termux ubuntu-18.04 bionic
# 适用于 Linux deploy ubuntu-18.04 bionic
# 适用于其他 ARM64平台 ubuntu-18.04 系统
# 此脚本将一键安装Yunzai-bot 喵喵插件 黄历插件 ffmpeg 
# 2022年5月17日01:31:26

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

echo 拉取所需资源
git clone https://gitee.com/Ganyu256/Yunzai.git ~/Yunzai

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

#安装pip3.8
python3.8 ~/Yunzai/get-pip.py
echo pip3.8升级成功
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
cd ~/
echo '克隆Yunzai-Bot开始';
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

# 克隆喵喵项目
echo '克隆喵喵插件开始';
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

# 克隆黄历项目
echo '克隆黄历插件';
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
echo
echo '安装黄历成功';
echo '这里报错请无视，使用"#黄历"命令不报错就行了';
rm /tmp/get-pip.py
echo '安装成功'...
echo

echo 下载所需资源中！
git clone https://gitee.com/Ganyu256/ffmpeg-install.git ~/ffmpeg-install
chmod -R 777 ~/ffmpeg-install
cd ~/ffmpeg-install
cd ./tmp
echo 
echo 下载ffmpeg
if [ ! -d "ffmpeg/" ];then
  git clone https://gitee.com/Ganyu256/FFmpeg.git ffmpeg
  if [ ! -d "ffmpeg/" ]; then
    echo "ffmpeg拉取失败"
    exit 0
  else
    echo "ffmpeg拉取成功！"
  fi
else
  echo "ffmpeg拉取成功"
fi
chmod -R 777 ./ffmpeg
echo 

cd ~/ffmpeg-install
echo 资源加载完成，可以开始安装！

echo 开始自动安装
cd ./tmp
echo
echo 部署系统编译环境：
apt install -y automake autoconf libtool gcc gcc- unzip
if [ $? -ne 0 ]; then
    echo "失败了！"
else
    echo "编译环境配置成功！"
fi

tar -xzvf ../res/yasm-1.3.0.tar.gz
chmod -R 777 ./yasm-1.3.0
cd yasm-1.3.0
echo 配置yasm源码
./configure --build=arm-linux
echo 编译yasm源码
make
echo 安装yasm
make install
cd ../
echo

echo
tar -xzvf ../res/lame-3.99.5.tar.gz 
chmod -R 777 ./lame-3.99.5
cd lame-3.99.5
echo 配置lame源码
./configure --build=arm-linux
echo 编译lame源码
make
echo 安装lame
make install
cd ../
echo

echo
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

echo
tar -xjvf ../res/amrnb-11.0.0.0.tar.bz2 
chmod -R 777 ./amrnb-11.0.0.0
cd amrnb-11.0.0.0
echo 配置amrnb源码
./configure
echo 编译amrnb源码
make
echo 安装amrnb源码
make install
cd ../
echo

echo
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
echo 自动安装完成！
echo
echo
echo termux-ubuntu自动配置Yunzai-Bot音频转码“ffmpeg相关依赖”，其他linux系统自测！x86平台自测！
echo 
echo

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
echo 清理安装文件
#rm -rf ./tmp/*
echo 部署完毕！
echo

echo 进行mp3转amr测试！
cd ~/ffmpeg-install
rm -rf ./test/*
ffmpeg -i ./res/test.mp3 -ac 1 -ar 8000 ./test/测试成功.amr
echo
echo 列出文件
ls ./test/
echo
echo 当你看到“测试成功.amr”文件时说明已经部署成功！
echo 使用方法：
echo ffmpeg -i 123.mp3 -ac 1 -ar 8000 123.amr       //mp3转amr
echo ffmpeg -i 123.amr 123.mp3      //amr转mp3

echo 你可以前往机器人进行测试！
echo 脚本编辑于2022-5-17 21:02:52
echo 编辑者QQ：2430248074 
echo      ▬▬.◙.▬▬
echo    ▂▄▄▓▄▄▂
echo ◢◤ █▀▀████▄▄▄▄▄◢◤
echo ██再见████▀▀▀▀╬
echo     ◥███████◤
echo     ══╩══╩══我走了，我不打扰！
echo
echo 你可以输入以下命令来清理安装文件
echo rm -rf ~/ffmpeg-install
echo 再见！！！
exit
