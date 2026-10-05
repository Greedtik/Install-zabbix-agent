# Zabbix Agent Auto Installer for Ubuntu

สคริปต์สำหรับติดตั้ง **Zabbix Agent** บน Ubuntu อย่างรวดเร็วผ่านคำสั่งเดียว (One-Liner) รองรับการตั้งค่าแบบถาม-ตอบ (Interactive) เพื่อกำหนด IP และ Hostname ได้ทันทีขณะติดตั้ง

## ✨ คุณสมบัติ (Features)
- 🚀 **รันคำสั่งเดียวจบ:** ไม่ต้องดาวน์โหลดสคริปต์มาแก้ค่าเอง
- 📝 **Interactive Prompts:** กำหนดค่า `Server`, `ServerActive` และ `Hostname` ผ่านหน้าจอ Terminal ได้ทันที
- 🐧 **Auto OS Detection:** ตรวจสอบเวอร์ชัน Ubuntu (Codename) และดึง Repository ให้ตรงรุ่นอัตโนมัติ
- ⚙️ **Auto Config & Start:** ระบบจะสำรองไฟล์ config เดิม, อัปเดตค่าใหม่ และเปิดให้ Service ทำงานตอนบูตเครื่อง (Enable on boot)

## 🚀 วิธีใช้งาน (How to Use)

คัดลอกคำสั่งด้านล่างไปวางใน Terminal ของเครื่อง Ubuntu ที่ต้องการติดตั้ง แล้วกด `Enter`:

```bash
curl -sL https://raw.githubusercontent.com/Greedtik/Install-zabbix-agent/refs/heads/main/install-zabbix-agent.sh | sudo bash

```


## ⌨️ ขั้นตอนการตั้งค่าระหว่างติดตั้ง
เมื่อรันคำสั่ง ระบบจะถามข้อมูล 3 ข้อ ดังนี้:

1.Enter Zabbix Server IP (Server):

     ระบุ IP Address ของ Zabbix Server (จำเป็นต้องระบุ)

2.Enter Zabbix ServerActive IP:

    ระบุ IP สำหรับโหมด Active Checks

    (หากต้องการใช้ IP เดียวกับข้อแรก สามารถกด Enter ผ่านได้เลย)

3.Enter Hostname for this agent:

    ระบุชื่อ Hostname ที่ใช้ตั้งค่าในหน้าเว็บ Zabbix Server

    (หากกด Enter ผ่าน ระบบจะดึงชื่อ Hostname ปัจจุบันของเครื่องมาใช้โดยอัตโนมัติ)

📂 ข้อมูลระบบที่เกี่ยวข้อง
Zabbix Version: 7.0 (ค่าเริ่มต้น)

Config Path: /etc/zabbix/zabbix_agentd.conf

Backup Path: /etc/zabbix/zabbix_agentd.conf.bak (ระบบทำสำเนาไฟล์เดิมไว้ให้ก่อนแก้ไข)
