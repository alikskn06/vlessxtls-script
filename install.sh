#!/bin/bash

# VLESS XTLS-Reality VPN Otomatik Kurulum Scripti
# Ubuntu 22.04 LTS ARM64 için optimize edilmiştir

set -e

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║     VLESS XTLS-Reality VPN Kurulum Scripti           ║
║     Ubuntu 22.04 LTS ARM64 Optimized                 ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Root kontrolü
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Bu script root olarak çalıştırılmalıdır!${NC}"
   echo "Lütfen 'sudo bash $0' komutuyla çalıştırın."
   exit 1
fi

echo -e "${GREEN}[1/8] Sistem güncelleniyor...${NC}"
apt update -y && apt upgrade -y

echo -e "${GREEN}[2/8] Gerekli paketler kuruluyor...${NC}"
apt install -y curl wget unzip jq ufw socat cron

echo -e "${GREEN}[3/8] Kullanıcı bilgileri alınıyor...${NC}"
echo ""
read -p "Sunucu IP adresi (örnek: 34.89.151.64): " SERVER_IP
if [[ -z "$SERVER_IP" ]]; then
    echo -e "${RED}IP adresi boş olamaz!${NC}"
    exit 1
fi

read -p "Port numarası [443]: " PORT
PORT=${PORT:-443}

read -p "Kaç kullanıcı eklemek istiyorsunuz? [3]: " USER_COUNT
USER_COUNT=${USER_COUNT:-3}

echo ""
echo -e "${YELLOW}Reality Destination (Maskeleme) Siteleri:${NC}"
echo "1. www.microsoft.com (Önerilen)"
echo "2. www.cloudflare.com"
echo "3. www.amazon.com"
echo "4. www.apple.com"
echo "5. www.google.com"
read -p "Seçiminiz [1]: " DEST_CHOICE
DEST_CHOICE=${DEST_CHOICE:-1}

case $DEST_CHOICE in
    1) DEST_SITE="www.microsoft.com" ;;
    2) DEST_SITE="www.cloudflare.com" ;;
    3) DEST_SITE="www.amazon.com" ;;
    4) DEST_SITE="www.apple.com" ;;
    5) DEST_SITE="www.google.com" ;;
    *) DEST_SITE="www.microsoft.com" ;;
esac

echo -e "${GREEN}[4/8] Xray-core kuruluyor...${NC}"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

echo -e "${GREEN}[5/8] UUID'ler ve keypair oluşturuluyor...${NC}"
# UUID'leri oluştur
UUIDS=()
for ((i=1; i<=$USER_COUNT; i++)); do
    UUID=$(xray uuid)
    UUIDS+=("$UUID")
    echo -e "${BLUE}User $i UUID: $UUID${NC}"
done

# Keypair oluştur
KEYS=$(xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep "Private key:" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEYS" | grep "Public key:" | awk '{print $3}')

# ShortID oluştur (8 karakter hex)
SHORT_ID=$(openssl rand -hex 8)

echo -e "${GREEN}[6/8] Config dosyası oluşturuluyor...${NC}"

# Clients JSON array oluştur
CLIENTS_JSON="["
for ((i=0; i<$USER_COUNT; i++)); do
    if [ $i -gt 0 ]; then
        CLIENTS_JSON+=","
    fi
    CLIENTS_JSON+="
          {
            \"id\": \"${UUIDS[$i]}\",
            \"flow\": \"xtls-rprx-vision\",
            \"email\": \"user$((i+1))\"
          }"
done
CLIENTS_JSON+="
        ]"

# Config dosyası oluştur
cat > /usr/local/etc/xray/config.json << EOF
{
  "log": {
    "loglevel": "warning",
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": $CLIENTS_JSON,
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "$DEST_SITE:443",
          "xver": 0,
          "serverNames": ["$DEST_SITE"],
          "privateKey": "$PRIVATE_KEY",
          "shortIds": ["", "$SHORT_ID"]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
        "domainStrategy": "UseIPv4"
      }
    },
    {
      "protocol": "blackhole",
      "tag": "block"
    }
  ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "protocol": ["bittorrent"],
        "outboundTag": "block"
      },
      {
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "block"
      }
    ]
  }
}
EOF

# Log klasörü oluştur
mkdir -p /var/log/xray
chown nobody:nogroup /var/log/xray

echo -e "${GREEN}[7/8] Firewall ayarları yapılıyor...${NC}"
ufw --force enable
ufw allow $PORT/tcp
ufw allow 22/tcp
ufw reload

echo -e "${GREEN}[8/8] Xray servisi başlatılıyor...${NC}"
systemctl enable xray
systemctl restart xray
sleep 2

# Servis durumu kontrolü
if systemctl is-active --quiet xray; then
    echo -e "${GREEN}✓ Xray servisi başarıyla çalışıyor!${NC}"
else
    echo -e "${RED}✗ Xray servisi başlatılamadı! Logları kontrol edin:${NC}"
    echo "journalctl -u xray -n 50"
    exit 1
fi

# Bağlantı bilgilerini kaydet
INFO_FILE="/root/xray-connection-info.txt"
cat > $INFO_FILE << EOF
╔═══════════════════════════════════════════════════════╗
║          XRAY REALITY VPN BAĞLANTI BİLGİLERİ         ║
╚═══════════════════════════════════════════════════════╝

Sunucu IP: $SERVER_IP
Port: $PORT
Protocol: VLESS + XTLS-Reality
Destination: $DEST_SITE
Public Key: $PUBLIC_KEY
Short ID: $SHORT_ID

════════════════════════════════════════════════════════

CLIENT BAĞLANTI LINKLERİ:

EOF

# Her kullanıcı için bağlantı linki oluştur
for ((i=0; i<$USER_COUNT; i++)); do
    USER_NUM=$((i+1))
    CONNECTION_LINK="vless://${UUIDS[$i]}@${SERVER_IP}:${PORT}?encryption=none&flow=xtls-rprx-vision&security=reality&sni=${DEST_SITE}&fp=chrome&pbk=${PUBLIC_KEY}&sid=${SHORT_ID}&type=tcp&headerType=none#User${USER_NUM}-Reality"
    
    echo "User $USER_NUM:" >> $INFO_FILE
    echo "$CONNECTION_LINK" >> $INFO_FILE
    echo "" >> $INFO_FILE
done

cat >> $INFO_FILE << EOF
════════════════════════════════════════════════════════

CLIENT UYGULAMALARI:
- Android: v2rayNG
- iOS: Streisand, Shadowrocket
- Windows: v2rayN, Hiddify
- macOS: V2Box, Hiddify
- Linux: Nekoray, Qv2ray

KULLANIM:
1. Yukarıdaki linklerden birini kopyalayın
2. Client uygulamasında "Import from clipboard" seçin
3. Bağlan!

════════════════════════════════════════════════════════

Yönetim Komutları:
- Servis durumu: systemctl status xray
- Restart: systemctl restart xray
- Logları görüntüle: tail -f /var/log/xray/access.log
- Config düzenle: nano /usr/local/etc/xray/config.json

Bu dosya konumu: $INFO_FILE
EOF

# Ekrana bilgileri yazdır
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            KURULUM BAŞARIYLA TAMAMLANDI!             ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Public Key:${NC} $PUBLIC_KEY"
echo -e "${YELLOW}Short ID:${NC} $SHORT_ID"
echo ""
echo -e "${BLUE}Tüm bağlantı bilgileri şu dosyaya kaydedildi:${NC}"
echo -e "${GREEN}$INFO_FILE${NC}"
echo ""
echo -e "${YELLOW}Bağlantı linklerini görmek için:${NC}"
echo "cat $INFO_FILE"
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}CLIENT BAĞLANTI LINKLERİ:${NC}"
echo ""

for ((i=0; i<$USER_COUNT; i++)); do
    USER_NUM=$((i+1))
    CONNECTION_LINK="vless://${UUIDS[$i]}@${SERVER_IP}:${PORT}?encryption=none&flow=xtls-rprx-vision&security=reality&sni=${DEST_SITE}&fp=chrome&pbk=${PUBLIC_KEY}&sid=${SHORT_ID}&type=tcp&headerType=none#User${USER_NUM}-Reality"
    
    echo -e "${YELLOW}User $USER_NUM:${NC}"
    echo "$CONNECTION_LINK"
    echo ""
done

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Kurulum tamamlandı! İyi kullanımlar! 🚀${NC}"
echo ""
