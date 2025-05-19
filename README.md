# NewsApp
📌 Proje Tanımı
Bu proje, çeşitli RSS kaynaklarından haberleri çeken, kategorilere ayıran ve kullanıcıların görüntüleyebileceği bir haber portalı uygulamasıdır.

✨ Özellikler
RSS Besleme Entegrasyonu: Haber kaynaklarından otomatik haber çekme

Kategorizasyon: Haberleri kategorilere göre filtreleme

Modern Arayüz: Responsive ve kullanıcı dostu tasarım

Veritabanı Entegrasyonu: MS Access veritabanı ile haber depolama

Detay Sayfaları: Haber detaylarını görüntüleme

🛠 Teknoloji Yığını
Frontend: HTML5, CSS3, JavaScript, Bootstrap

Backend: ASP.NET (C#)

Veritabanı: Microsoft Access (.accdb)

Diğer: XML Parsing, RSS Feed Integration

📂 Proje Yapısı
HaberPortali/
├── App_Data/
│   └── NewsDB.accdb        # Veritabanı dosyası
├── App_Code/
│   └── News.cs             # Haber modeli
|   
├── Home.aspx               # Ana sayfa
├── RSSparsing.aspx         # RSS Çekici
|── NewsDetail.aspx         # Haber detay sayfası

🚀 Kurulum ve Çalıştırma
Gereksinimler:

Visual Studio (2019 veya üzeri)

.NET Framework 4.7+

Microsoft Access veya Access Runtime

Adımlar:

bash
git clone https://github.com/meturk0/NewsApp.git
cd NewsApp
Projeyi Visual Studio'da açın

NewsDB.accdb dosyasını kontrol edin (App_Data klasöründe)

Projeyi derleyip çalıştırın

🔧 Yapılandırma
RSS Kaynaklarını Düzenleme:
RSSparsing.aspx.cs dosyasında rssFeedsByCategory dictionary'sini güncelleyin:

csharp
private readonly Dictionary<string, string> rssFeedsByCategory = new Dictionary<string, string>()
{
    {"Teknoloji", "https://www.ornek.com/teknoloji.rss"},
    // Yeni kaynaklar ekleyebilirsiniz
};
Veritabanı Bağlantısı:
Bağlantı string'ini Web.config'de düzenleyin:

xml
<connectionStrings>
  <add name="NewsDB" 
       connectionString="Provider=Microsoft.ACE.OLEDB.12.0;Data Source=|DataDirectory|\NewsDB.accdb"
       providerName="System.Data.OleDb" />
</connectionStrings>
🌐 Kullanım
Haberleri Çekme:

/RSSparsing.aspx sayfasına gidin

"Haberleri Çek" butonuna basın

İsteğe bağlı: "Mevcut haberleri temizle" seçeneğini işaretleyin

Haberleri Görüntüleme:

Ana sayfada kategoriler arasında gezinin

Haber kartlarına tıklayarak detayları görüntüleyin

📝 Veritabanı Şeması
sql
CREATE TABLE News (
    NewsID AUTOINCREMENT PRIMARY KEY,
    Title TEXT,
    Description MEMO,
    Category TEXT,
    Author TEXT,
    PubDate DATETIME,
    ImageUrl TEXT
)


📞 İletişim
Proje sahibi: Muhammet Emin Türk - meturk00@gmail.com
