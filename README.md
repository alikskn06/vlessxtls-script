# VLESS XTLS-Reality VPN Kurulum Scripti

Ubuntu 22.04 LTS ARM64 için optimize edilmiş, tam otomatik VLESS + XTLS-Reality protokolü VPN kurulum scripti.

## 🚀 Özellikler

- ✅ Tek komutla tam otomatik kurulum
- ✅ VLESS + XTLS-Reality protokolü (En güvenli ve hızlı)
- ✅ Domain gerektirmez
- ✅ DPI bypass (Derin paket incelemesi atlatma)
- ✅ Çoklu kullanıcı desteği
- ✅ Otomatik firewall yapılandırması
- ✅ Client bağlantı linkleri otomatik üretilir
- ✅ ARM64 optimizasyonu

## 📋 Gereksinimler

- Ubuntu 22.04 LTS (ARM64 veya x86_64)
- Root erişimi
- Açık internet bağlantısı
- En az 512MB RAM

## 🛠️ Kurulum

### Hızlı Kurulum (Tek Satır)

```bash
wget https://raw.githubusercontent.com/alikskn06/vlessxtls-script/main/install.sh && chmod +x install.sh && sudo bash install.sh
```

### Manuel Kurulum

```bash
# Script'i indir
wget https://raw.githubusercontent.com/alikskn06/vlessxtls-script/main/install.sh

# Çalıştırılabilir yap
chmod +x install.sh

# Root olarak çalıştır
sudo bash install.sh
```

## 📱 Script Size Soracak Sorular

1. **Sunucu IP adresi**: VPS'inizin public IP'si (örn: 34.89.151.64)
2. **Port numarası**: Varsayılan 443 (önerilir)
3. **Kullanıcı sayısı**: Kaç kişi kullanacak (varsayılan 3)
4. **Reality Destination**: Maskeleme sitesi (varsayılan Microsoft)

## 🎯 Reality Protocol Nedir?

Reality, VPN trafiğinizi gerçek bir HTTPS sitesi trafiği gibi gösterir. Örneğin Microsoft.com'a bağlanıyormuş gibi görünür. Bu sayede:

- ✅ DPI sistemleri VPN tespit edemez
- ✅ Domain'e ihtiyaç yok
- ✅ Çok yüksek güvenlik
- ✅ Hızlı bağlantı

## 📊 Kurulum Sonrası

Script tamamlandığında şu dosyada tüm bilgiler olacak:

```bash
cat /root/xray-connection-info.txt
```

Bu dosyada bulacaklarınız:
- ✅ Client bağlantı linkleri (Her kullanıcı için)
- ✅ Public Key
- ✅ Short ID
- ✅ Yönetim komutları

## 📲 Client Uygulamaları

### Android
- [v2rayNG](https://github.com/2dust/v2rayNG/releases)

### iOS
- Streisand (App Store)
- Shadowrocket (App Store - Ücretli)

### Windows
- [v2rayN](https://github.com/2dust/v2rayN/releases)
- [Hiddify](https://github.com/hiddify/hiddify-next/releases)

### macOS
- V2Box (App Store)
- [Hiddify](https://github.com/hiddify/hiddify-next/releases)

### Linux
- [Nekoray](https://github.com/MatsuriDayo/nekoray/releases)

## 🔧 Yönetim Komutları

```bash
# Servis durumu
systemctl status xray

# Servisi yeniden başlat
systemctl restart xray

# Logları görüntüle
tail -f /var/log/xray/access.log

# Config dosyasını düzenle
nano /usr/local/etc/xray/config.json

# Bağlantı bilgilerini görüntüle
cat /root/xray-connection-info.txt
```

## 🔒 Güvenlik Özellikleri

- ✅ XTLS-Reality protokolü (TLS 1.3)
- ✅ Otomatik firewall yapılandırması
- ✅ BitTorrent engelleme
- ✅ Private IP engelleme
- ✅ Traffic sniffing koruması

## 🌍 Port Önerileri

- **443**: HTTPS - En çok önerilen (DPI bypass)
- **80**: HTTP - Alternatif
- **8443**: Custom HTTPS
- **2096**: Cloudflare compat

## ❓ Sorun Giderme

### Servis başlamıyor
```bash
journalctl -u xray -n 50
```

### Bağlantı kurulamıyor
1. Firewall kontrolü: `ufw status`
2. Port açık mı: `netstat -tulpn | grep xray`
3. Config doğru mu: `xray run -test -c /usr/local/etc/xray/config.json`

### Client bağlanamıyor
- Public key'i doğru kopyaladınız mı?
- ShortID doğru mu?
- Sunucu IP'si doğru mu?
- Port açık mı?

## 📈 Performans İyileştirmeleri

Script otomatik olarak şunları yapar:
- ✅ TCP optimizasyonu
- ✅ BBR congestion control (mevcut ise)
- ✅ Log rotation
- ✅ IPv4 önceliği

## 🔄 Güncelleme

```bash
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
systemctl restart xray
```

## 🗑️ Kaldırma

```bash
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
```

## 📝 Lisans

Bu script MIT lisansı altındadır. Özgürce kullanabilirsiniz.

## 🤝 Katkıda Bulunma

Pull request'ler hoş geldiniz! Büyük değişiklikler için lütfen önce issue açın.

## ⚠️ Yasal Uyarı

Bu araç sadece eğitim amaçlıdır. Yerel yasalara uygun kullanımdan siz sorumlusunuz.

## 📞 Destek

Sorun yaşıyorsanız:
1. README'yi dikkatlice okuyun
2. Issues bölümünde benzer sorunları arayın
3. Yeni issue açın (log dosyalarını ekleyin)

## 🌟 Özellikler Roadmap

- [ ] WebSocket desteği
- [ ] gRPC transport
- [ ] Otomatik SSL sertifikası
- [ ] Web panel
- [ ] Traffic istatistikleri

---

**⭐ Beğendiyseniz yıldız vermeyi unutmayın!**

Made with ❤️ for a free internet
