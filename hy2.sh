#!/bin/bash

# 提示用户输入域名
read -p "请输入域名: " domain

# 检查用户是否输入了域名，如果未输入则提示并退出
if [ -z "$domain" ]; then
    echo "错误: 域名不能为空。"
    exit 1
fi

# Issue certificate
~/.acme.sh/acme.sh --issue -d "$domain" --standalone

# Install key file
~/.acme.sh/acme.sh --install-cert -d "$domain" --key-file /root/hysteria/example.com.key

# Install full chain file
~/.acme.sh/acme.sh --install-cert -d "$domain" --fullchain-file /root/hysteria/example.com.crt

echo "证书安装完成。域名: $domain"
