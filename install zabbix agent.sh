#!/bin/bash

# ตรวจสอบสิทธิ์ Root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root (use sudo)"
  exit 1
fi

echo "========================================="
echo "   Zabbix Agent Interactive Installer"
echo "========================================="

# 1. รับค่า Server IP (บังคับใส่)
read -p "Enter Zabbix Server IP (Server): " ZABBIX_SERVER < /dev/tty
if [ -z "$ZABBIX_SERVER" ]; then
  echo "Error: Zabbix Server IP is required. Aborted."
  exit 1
fi

# 2. รับค่า ServerActive IP (ถ้ากด Enter เปล่าๆ จะใช้ค่าเดียวกับ Server)
read -p "Enter Zabbix ServerActive IP [Press Enter to use $ZABBIX_SERVER]: " ZABBIX_SERVER_ACTIVE < /dev/tty
if [ -z "$ZABBIX_SERVER_ACTIVE" ]; then
  ZABBIX_SERVER_ACTIVE=$ZABBIX_SERVER
fi

# 3. รับค่า Hostname (ถ้ากด Enter เปล่าๆ จะใช้ชื่อเครื่องปัจจุบัน)
DEFAULT_HOSTNAME=$(hostname)
read -p "Enter Hostname for this agent [Press Enter to use '$DEFAULT_HOSTNAME']: " ZABBIX_HOSTNAME < /dev/tty
if [ -z "$ZABBIX_HOSTNAME" ]; then
  ZABBIX_HOSTNAME=$DEFAULT_HOSTNAME
fi

echo ""
echo "--- Installation Starting ---"

# ตัวแปรระบบ
OS_CODENAME=$(lsb_release -cs)
ZABBIX_VERSION="7.0"

# ดาวน์โหลดและติดตั้ง Zabbix Repository
wget https://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VERSION}-2+ubuntu${OS_CODENAME}_all.deb -O zabbix-release.deb
dpkg -i zabbix-release.deb
apt-get update -y

# ติดตั้ง Zabbix Agent
apt-get install zabbix-agent -y

# สำรองไฟล์ Config เดิม
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak

# ตั้งค่า Zabbix Server, ServerActive และ Hostname
CONF_FILE="/etc/zabbix/zabbix_agentd.conf"
sed -i "s/^Server=127.0.0.1/Server=$ZABBIX_SERVER/" $CONF_FILE
sed -i "s/^ServerActive=127.0.0.1/ServerActive=$ZABBIX_SERVER_ACTIVE/" $CONF_FILE
sed -i "s/^Hostname=Zabbix server/Hostname=$ZABBIX_HOSTNAME/" $CONF_FILE

# Start และ Enable Service ให้ทำงานตอนบูตเครื่อง
systemctl restart zabbix-agent
systemctl enable zabbix-agent

# ลบไฟล์ติดตั้ง
rm zabbix-release.deb

echo "========================================="
echo " Zabbix Agent Installed Successfully!"
echo " Server       : $ZABBIX_SERVER"
echo " ServerActive : $ZABBIX_SERVER_ACTIVE"
echo " Hostname     : $ZABBIX_HOSTNAME"
echo "========================================="
