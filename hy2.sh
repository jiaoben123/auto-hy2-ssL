#!/bin/bash

# 检查是否已存在 auto-hy2-ssL 目录，如果存在则删除
if [ -d "auto-hy2-ssL" ]; then
    echo "检测到已存在 auto-hy2-ssL 目录，正在删除..."
    rm -rf auto-hy2-ssL
fi

# 安装必要的软件并设置 acme.sh
sudo apt install -y vim curl socat openssl && mkdir -p /root/hysteria && \
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

echo "证书安装完成。域名: $domain"
