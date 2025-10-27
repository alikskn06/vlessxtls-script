# VLESS XTLS VPN Kurulum Scriptleri

Ubuntu 22.04 LTS için 2 farklı VLESS XTLS kurulum seçeneği:

## 📌 HANGİSİNİ SEÇMELİYİM?

### 🔒 **Reality Versiyonu** (Güvenlik & DPI Bypass)
En güvenli seçenek. Trafiğinizi gerçek bir siteye benzetiyor.
- ✅ DPI Bypass (Türkiye gibi sansür olan ülkeler için)
- ✅ En yüksek güvenlik
- ✅ Çok hızlı (XTLS-Vision + Reality)
- ❌ SNI sabit (destination ile aynı olmalı)

### 🎯 **BugHost Versiyonu** (Bedava İnternet / SNI Trick)
Operatör ücretsiz uygulamalarını kullanarak bedava internet.
- ✅ SNI özgürce değiştirilebilir
- ✅ BugHost mantığı (WhatsApp, Instagram SNI trick)
- ✅ Hızlı (XTLS-Vision + TLS)
- ❌ DPI bypass yok
- ❌ Güvenlik Reality'den düşük

---

## 📋 Gereksinimler

- Ubuntu 22.04 LTS (ARM64 veya x86_64)
- Root erişimi
- Açık internet bağlantısı
- En az 512MB RAM

---

## 🛠️ Kurulum

### 🔒 Reality Versiyonu (Güvenli & DPI Bypass)

**Tek Satır Kurulum:**
```bash
wget https://raw.githubusercontent.com/alikskn06/vlessxtls-script/main/install-reality.sh && chmod +x install-reality.sh && sudo bash install-reality.sh
```

### 🎯 BugHost Versiyonu (Bedava İnternet / SNI Trick)

**Tek Satır Kurulum:**
```bash
wget https://raw.githubusercontent.com/alikskn06/vlessxtls-script/main/install-bughost.sh && chmod +x install-bughost.sh && sudo bash install-bughost.sh
```

---

## 📊 Script Size Soracak Sorular

### Reality Versiyonu:
1. **Sunucu IP adresi**: VPS'inizin public IP'si
2. **Port numarası**: Varsayılan 443 (önerilir)
3. **Kullanıcı sayısı**: Kaç kişi kullanacak (varsayılan 3)
4. **Reality Destination**: Maskeleme sitesi (varsayılan Microsoft)

### BugHost Versiyonu:
1. **Sunucu IP adresi**: VPS'inizin public IP'si
2. **Port numarası**: Varsayılan 443 (önerilir)
3. **Kullanıcı sayısı**: Kaç kişi kullanacak (varsayılan 3)

---

## 🎯 Reality Protocol Nedir?

Reality, VPN trafiğinizi gerçek bir HTTPS sitesi trafiği gibi gösterir. Örneğin Microsoft.com'a bağlanıyormuş gibi görünür. Bu sayede:

- ✅ DPI sistemleri VPN tespit edemez
- ✅ Domain'e ihtiyaç yok
- ✅ Çok yüksek güvenlik
- ✅ Hızlı bağlantı (XTLS-Vision)

---

## 🎯 BugHost / SNI Trick Nedir?

SNI (Server Name Indication) alanını operatörün ücretsiz sunduğu uygulamaya ayarlayarak bedava internet:

### Nasıl Çalışır?
1. Client'ta SNI alanını operatörün ücretsiz sunduğu uygulamaya ayarla
2. Örnek: `www.whatsapp.com`, `www.instagram.com`, `www.spotify.com`
3. Operatör SNI'ye bakıp "bu WhatsApp trafiği" sanır ve ücretsiz geçirir
4. Gerçekte tüm internet trafiğiniz geçer!

### Önerilen Ücretsiz SNI'ler:
- `www.whatsapp.com` (WhatsApp paketi varsa)
- `www.instagram.com` (Instagram paketi varsa)
- `www.facebook.com` (Facebook paketi varsa)
- `www.spotify.com` (Spotify paketi varsa)
- `www.twitter.com` (Twitter paketi varsa)
- `www.tiktok.com` (TikTok paketi varsa)

**⚠️ NOT:** Operatörünüzün hangi uygulamaları ücretsiz sunduğunu öğrenin!

---

## 📊 Kurulum Sonrası

### Reality Versiyonu:
```bash
cat /root/xray-reality-info.txt
```

Bu dosyada:
- ✅ Client bağlantı linkleri
- ✅ Public Key
- ✅ Short ID
- ✅ Destination domain

### BugHost Versiyonu:
```bash
cat /root/xray-bughost-info.txt
```

Bu dosyada:
- ✅ Client bağlantı linkleri (XTLS-Vision)
- ✅ SNI özelleştirme talimatları
- ✅ Önerilen ücretsiz SNI'ler

---

## 📱 Client Uygulamaları

### Android
- [v2rayNG](https://github.com/2dust/v2rayNG/releases)
- [Hiddify](https://github.com/hiddify/hiddify-next/releases)

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

---

## ⚙️ BugHost için SNI Özelleştirme

### v2rayNG (Android):
1. Profili düzenle
2. "Server name indication (SNI)" alanını bul
3. Örnek: `www.whatsapp.com` yaz
4. **"Allow insecure" seçeneğini AÇ** (🔒 bypass için)
5. Kaydet ve bağlan

### Hiddify (Tüm Platformlar):
1. Config'i düzenle
2. "SNI" veya "Server Name" alanını değiştir
3. Örnek: `www.spotify.com`
4. **"Skip Certificate Verification" AÇIK olmalı**
5. Uygulayıp bağlan

### v2rayN (Windows):
1. Server config'i düzenle
2. "SNI" alanını güncelle
3. **"AllowInsecure" seç**
4. Kaydet

---

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

# Bağlantı bilgilerini görüntüle (Reality)
cat /root/xray-reality-info.txt

# BugHost versiyonu için
cat /root/xray-bughost-info.txt

# Config test
xray run -test -c /usr/local/etc/xray/config.json
```

---

## 🔒 Güvenlik Özellikleri

- ✅ XTLS-Reality/Vision protokolü (TLS 1.3)
- ✅ Otomatik firewall yapılandırması
- ✅ Private IP engelleme
- ✅ Traffic routing optimizasyonu

---

## 🌍 Port Önerileri

- **443**: HTTPS - En çok önerilen (DPI bypass)
- **80**: HTTP - Alternatif
- **8443**: Custom HTTPS
- **2096**: Cloudflare compat

---

## ❓ Sorun Giderme

### Servis başlamıyor
```bash
journalctl -u xray -n 50
```

### Bağlantı kurulamıyor
1. Firewall kontrolü: `ufw status`
2. Port açık mı: `netstat -tulpn | grep xray`
3. Config doğru mu: `xray run -test -c /usr/local/etc/xray/config.json`

### Client bağlanamıyor (Reality)
- Public key'i doğru kopyaladınız mı?
- ShortID doğru mu?
- Sunucu IP'si doğru mu?
- Port açık mı?

### Client bağlanamıyor (BugHost)
- SNI'yi client'ta ayarladınız mı?
- "Allow insecure" / "Skip cert verify" açık mı?
- Doğru ücretsiz SNI kullanıyor musunuz?

---

## 📈 Performans İyileştirmeleri

Script otomatik olarak şunları yapar:
- ✅ TCP optimizasyonu
- ✅ BBR congestion control (mevcut ise)
- ✅ Log rotation
- ✅ IPv4 önceliği

---

## 🔄 Güncelleme

```bash
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
systemctl restart xray
```

---

## 🗑️ Kaldırma

```bash
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
```

---

## 📝 Lisans

Bu script MIT lisansı altındadır. Özgürce kullanabilirsiniz.

---

## 🤝 Katkıda Bulunma

Pull request'ler hoş geldiniz! Büyük değişiklikler için lütfen önce issue açın.

---

## ⚠️ Yasal Uyarı

Bu araç sadece eğitim amaçlıdır. Yerel yasalara uygun kullanımdan siz sorumlusunuz.

---

## 📞 Destek

Sorun yaşıyorsanız:
1. README'yi dikkatlice okuyun
2. Issues bölümünde benzer sorunları arayın
3. Yeni issue açın (log dosyalarını ekleyin)

---

## 🌟 Özellikler

- [x] VLESS + XTLS-Reality (DPI bypass)
- [x] VLESS + XTLS-Vision (BugHost/SNI trick)
- [x] Otomatik kurulum
- [x] Çoklu kullanıcı desteği
- [x] Firewall yapılandırması
- [x] Self-signed TLS (BugHost için)
- [ ] WebSocket desteği
- [ ] gRPC transport
- [ ] Web panel
- [ ] Traffic istatistikleri

---

**⭐ Beğendiyseniz yıldız vermeyi unutmayın!**

Made with ❤️ for a free internet
