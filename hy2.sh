#!/bin/bash

# 创建目录并切换到目录
mkdir -p /root/hysteria && cd /root/hysteria

# 下载必要文件并删除压缩文件
wget https://github.com/jiaoben123/auto-hy2-ssL/archive/refs/heads/main.zip && unzip main.zip && \
mv auto-hy2-ssL-main/docker-compose.yml auto-hy2-ssL-main/server.yaml auto-hy2-ssL-main/hy2.sh . && \
rm -rf main.zip auto-hy2-ssL-main

# 安装必要的软件并设置 acme.sh
sudo apt install -y vim curl socat openssl && \
curl https://get.acme.sh | sh -s email=rebecca554owen@gmail.com && \
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# 提示用户输入域名
read -p "请输入域名: " domain

# 检查用户是否输入了域名，如果未输入则提示并退出
if [ -z "$domain" ]; then
    echo "错误: 域名不能为空。"
    exit 1
fi

# 颁发证书
~/.acme.sh/acme.sh --issue -d "$domain" --standalone

# 安装密钥文件
~/.acme.sh/acme.sh --install-cert -d "$domain" --key-file /root/hysteria/example.com.key

# 安装完整链文件
~/.acme.sh/acme.sh --install-cert -d "$domain" --fullchain-file /root/hysteria/example.com.crt

# 执行 hy2.sh 脚本
chmod +x hy2.sh && ./hy2.sh

# 提示用户进行 server.yaml 文件修改和 Docker 启动
echo -e "\n证书安装完成。域名: $domain"
echo -e "\n请按照以下示例修改 server.yaml 文件，然后运行命令启动 Docker 容器："
echo -e "\nserver.yaml 文件修改示例："
echo -e "\nv2board:"
echo -e "  apiHost:  # xboard面板域名"
echo -e "  apiKey:   # 通讯密钥"
echo -e "  nodeID: 1 # Hysteria节点id"
echo -e "\n修改完成后，运行以下命令启动 Docker 容器："
echo -e "\ndocker-compose up -d"
