<p align="center">
  <img src="assets/tickbuy_logo.png" width="220" alt="TickBuy Logo">
</p>

<h1 align="center">🛒 TickBuy - Alışveriş Listesi</h1>

<p align="center">
  <img src="https://img.shields.io/badge/flutter-%2302569B.svg?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/hive-%23FFCD00.svg?style=for-the-badge&logo=hive&logoColor=black" alt="Hive">
</p>

<p align="center">
  TickBuy, alışveriş süreçlerinizi dijitalleştirerek daha düzenli hale getiren, kullanıcı dostu ve şık tasarımlı bir Flutter uygulamasıdır. Ürünlerinizi kategorize edebilir, aciliyet durumlarını belirleyebilir ve harcamalarınızı kolayca takip edebilirsiniz.
</p>

---

### 💻 Tech Stack & İstatistikler
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat-square&logo=dart&logoColor=white) ![Flutter](https://img.shields.io/badge/flutter-%2302569B.svg?style=flat-square&logo=flutter&logoColor=white) ![Hive](https://img.shields.io/badge/database-Hive-blue?style=flat-square) 

![](https://github-readme-stats.vercel.app/api/pin/?username=sudenrkra&repo=tickBuy_app&theme=tokyonight&show_owner=true)

---

### ✨ Özellikler
- 📑 **Çoklu Liste Yönetimi:** Farklı ihtiyaçlarınız için (Market, Ev, İş vb.) ayrı listeler oluşturun.
- 📈 **İlerleme Takibi:** Listenizdeki ürünlerin tamamlanma oranını görsel bar üzerinden izleyin.
- 🚨 **Acil Durum Etiketi:** Kritik ürünleri "Acil" olarak işaretleyin ve kırmızı vurguyla görün.
- ↔️ **Kaydırarak Silme:** Modern kullanıcı deneyimi için listeleri tek bir hareketle yönetin.
- 💰 **Tahmini Fiyatlandırma:** Ürünlere fiyat ekleyerek bütçenizi önceden planlayın.
- 🔐 **Yerel Veritabanı:** Hive entegrasyonu ile internetiniz olmasa bile verileriniz cihazınızda güvende.
- 🚀 **Splash Screen:** Uygulama açılışında şık bir logo animasyonu.

---

### 📸 Ekran Görüntüleri

<p align="center">
  <img src="assets/screenshots/splash.png" width="200"> 
  <img src="assets/screenshots/home.png" width="200">
  <img src="assets/screenshots/detail.png" width="200">
  <img src="assets/screenshots/create.png" width="200">
</p>

---

### 🎥 Tanıtım Videosu
Uygulamanın nasıl çalıştığını buradan izleyebilirsiniz:
[![Watch the video](https://img.shields.io/badge/YouTube-Video%20İzle-red?style=for-the-badge&logo=youtube)](https://youtu.be/083Q9F-g0nE)

---

### 📦 Kurulum & APK
Uygulamanın **APK sürümü**, GitHub Releases üzerinden paylaşılmıştır.

👉 [**APK’yı İndir (v1.0.0)**](https://github.com/sudenrkra/tickBuy_app/releases/tag/v1.0.0)

> **Not:** Kurulum sırasında gerekirse “Bilinmeyen kaynaklara izin ver” seçeneğini aktif etmeniz yeterlidir.

---

### 📁 Proje Yapısı
```text
lib/
 ├── models/          # Veri modelleri (UrunOgesi, AlisverisListesi)
 ├── screens/         # UI Ekranları (Home, Detail, Create, Splash)
 ├── services/        # Veri yönetimi ve Provider sınıfları
 └── main.dart        # Uygulama giriş noktası
