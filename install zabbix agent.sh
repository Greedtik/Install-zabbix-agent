#!/bin/bash

# ตรวจสอบสิทธิ์ Root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root (use sudo)"
  exit 1
fi

# ตรวจสอบว่ามีการระบุ Hostname มาหรือไม่ (บังคับกรอก)
CUSTOM_HOSTNAME=$1
if [ -z "$CUSTOM_HOSTNAME" ]; then
  echo "Error: Missing Hostname!"
  echo "Usage: curl -s <git_raw_url> | sudo bash -s -- <Your_Hostname>"
  exit 1
fi

# กำหนดค่า IP ของ Zabbix Server (แบบตายตัวตามที่คุณต้องการ)
ZABBIX_SERVER="203.151.50.174"
ZABBIX_SERVER_ACTIVE="203.151.50.253"

# เช็คเวอร์ชันของ Ubuntu OS
OS_CODENAME=$(lsb_release -cs)
ZABBIX_VERSION="7.0" # ปรับเวอร์ชัน Zabbix ได้ตามต้องการ

echo "Starting Zabbix Agent installation for Ubuntu $OS_CODENAME..."
echo "Setting Hostname to: $CUSTOM_HOSTNAME"

# ดาวน์โหลดและติดตั้ง Zabbix Repository
wget https://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VERSION}-2+ubuntu${OS_CODENAME}_all.deb -O zabbix-release.deb
dpkg -i zabbix-release.deb
apt-get update -y

# ติดตั้ง Zabbix Agent
apt-get install zabbix-agent -y

# สำรองไฟล์ Config เดิม
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak

# ตั้งค่า Configuration ของ Zabbix Agent
CONF_FILE="/etc/zabbix/zabbix_agentd.conf"
sed -i "s/^Server=127.0.0.1/Server=$ZABBIX_SERVER/" $CONF_FILE
sed -i "s/^ServerActive=127.0.0.1/ServerActive=$ZABBIX_SERVER_ACTIVE/" $CONF_FILE
sed -i "s/^Hostname=Zabbix server/Hostname=$CUSTOM_HOSTNAME/" $CONF_FILE

# Start และ Enable Service ให้ทำงานตอนบูตเครื่อง
systemctl restart zabbix-agent
systemctl enable zabbix-agent

# ลบไฟล์ติดตั้งที่ดาวน์โหลดมา
rm zabbix-release.deb

echo "---------------------------------------------------"
echo " Zabbix Agent Installed Successfully!"
echo " Server       : $ZABBIX_SERVER"
echo " ServerActive : $ZABBIX_SERVER_ACTIVE"
echo " Hostname     : $CUSTOM_HOSTNAME"
echo "---------------------------------------------------"
