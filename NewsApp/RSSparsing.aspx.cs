using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Net;
using System.Xml;
using System.Web.UI;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using NewsApp.App_Code;

namespace NewsApp
{
    public partial class RSSparsing : System.Web.UI.Page
    {
        // Kategorilere göre RSS besleme URL'lerini tutan sözlük
        private readonly Dictionary<string, string> rssFeedsByCategory = new Dictionary<string, string>()
        {
            {"Turkiye", "https://www.ornek.com.tr/turkiye.rss"},
            {"Dunya", "https://www.ornek.com.tr/dunya.rss"},
            {"Ekonomi", "https://www.ornek.com.tr/ekonomi.rss"},
            {"Spor", "https://www.ornek.com.tr/spor.rss"},
            {"Saglik", "https://www.ornek.com.tr/saglik.rss"},
            {"Teknoloji", "https://www.ornek.com/teknoloji.rss"}
        };

        // 'Haberleri Çek' butonuna tıklandığında çalışacak metod
        protected void btnParse_Click(object sender, EventArgs e)
        {
            ArrayList allNewsList = new ArrayList(); // Tüm haberleri tutacak liste
            int totalNewsCount = 0; // Toplam haber sayacı

            try
            {
                // Eğer checkbox işaretliyse veritabanını temizle
                if (chkClearExisting.Checked)
                {
                    ClearDatabase();
                }

                // Her kategori için RSS beslemesini işle
                foreach (var feed in rssFeedsByCategory)
                {
                    string category = feed.Key; // Kategori adı
                    string rssUrl = feed.Value; // RSS URL'si

                    // Durum mesajına işlenen kategori bilgisini ekle
                    lblStatus.Text += $"<br/><strong>{category} kategorisi işleniyor...</strong>";

                    // Kategoriye ait haberleri çek
                    ArrayList categoryNewsList = ParseRssFeed(rssUrl, category);
                    allNewsList.AddRange(categoryNewsList); // Tüm haberler listesine ekle
                    totalNewsCount += categoryNewsList.Count; // Toplam habere ekle

                    // Durum mesajına eklenen haber sayısını yaz
                    lblStatus.Text += $"<br/>{category}: {categoryNewsList.Count} haber eklendi.";
                }

                // Haber listesini session'da sakla (gerekirse)
                Session["NewsList"] = allNewsList;
                // İşlem tamamlandı mesajı göster
                lblStatus.Text += $"<br/><br/><span style='color:green'>Toplam {totalNewsCount} haber başarıyla işlendi.</span>";
            }
            catch (Exception ex)
            {
                // Hata durumunda mesaj göster
                lblStatus.Text += "<br/><span style='color:red'>Hata: " + ex.Message + "</span>";
                LogError(ex, "Multiple feeds"); // Hatayı logla
            }
            statusContainer.Visible = true;
        }

        // Belirtilen RSS beslemesindeki haberleri çeken metod
        private ArrayList ParseRssFeed(string rssUrl, string category)
        {
            ArrayList newsList = new ArrayList(); // Haber listesi

            try
            {
                // RSS içeriğini indir
                string xmlContent = DownloadRssContent(rssUrl);
                // Geçersiz XML karakterlerini temizle
                xmlContent = RemoveInvalidXmlChars(xmlContent);

                // XML dokümanını yükle
                XmlDocument rssXmlDoc = new XmlDocument();
                rssXmlDoc.LoadXml(xmlContent);

                // Namespace yöneticisi oluştur (Atom feed'leri için)
                XmlNamespaceManager nsMgr = new XmlNamespaceManager(rssXmlDoc.NameTable);
                nsMgr.AddNamespace("a", "http://www.w3.org/2005/Atom");

                // Tüm entry'leri (haber girişlerini) seç
                XmlNodeList entries = rssXmlDoc.SelectNodes("//a:entry", nsMgr);
                int id = 1; // Haber ID sayacı

                // Her haber girişini işle
                foreach (XmlNode entry in entries)
                {
                    // XML entry'sini haber nesnesine dönüştür
                    News news = ParseAtomEntry(entry, id++, nsMgr, category);
                    if (news != null) // Dönüşüm başarılıysa
                    {
                        newsList.Add(news); // Listeye ekle
                        SaveSingleNewsToDatabase(news); // Veritabanına kaydet
                    }
                }
            }
            catch (Exception ex)
            {
                // Hata durumunda mesaj göster
                lblStatus.Text += $"<br/><span style='color:orange'>{category} kategorisinde hata: {ex.Message}</span>";
                LogError(ex, rssUrl); // Hatayı logla
            }

            return newsList; // Haber listesini döndür
        }

        // Tek bir Atom entry'sini haber nesnesine dönüştüren metod
        private News ParseAtomEntry(XmlNode entry, int id, XmlNamespaceManager nsMgr, string category)
        {
            try
            {
                // Haber başlığını al (yoksa boş string)
                string title = CleanText(entry.SelectSingleNode("a:title", nsMgr)?.InnerText ?? "");
                string description = ""; // Haber açıklaması
                string pubDate = entry.SelectSingleNode("a:published", nsMgr)?.InnerText ?? ""; // Yayın tarihi
                string author = entry.SelectSingleNode("a:author/a:name", nsMgr)?.InnerText ?? "NTV"; // Yazar (varsayılan: NTV)
                string imageUrl = ""; // Resim URL'si

                // İçerik düğümünü al
                var contentNode = entry.SelectSingleNode("a:content", nsMgr);
                if (contentNode != null)
                {
                    string htmlContent = contentNode.InnerText; // HTML içeriği
                    description = CleanText(htmlContent); // Temizlenmiş metin

                    // HTML içindeki resim URL'sini bul
                    Match imgMatch = Regex.Match(htmlContent, @"<img[^>]+src\s*=\s*[""'](?<src>[^""']+)[""']", RegexOptions.IgnoreCase);
                    if (imgMatch.Success)
                        imageUrl = imgMatch.Groups["src"].Value; // Resim URL'sini al
                }

                // Yayın tarihini formatla
                if (DateTime.TryParse(pubDate, out DateTime date))
                {
                    pubDate = date.ToString("yyyy-MM-dd HH:mm:ss");
                }

                // Yeni haber nesnesi oluştur ve döndür
                return new News(id, title, description, category, author, pubDate, imageUrl);
            }
            catch (Exception ex)
            {
                // Hata durumunda debug çıktısı ver
                System.Diagnostics.Debug.WriteLine($"Atom entry ayrıştırma hatası (ID: {id}): {ex.Message}");
                return null; // Hata durumunda null döndür
            }
        }

        // Tek bir haberi veritabanına kaydeden metod
        private void SaveSingleNewsToDatabase(News news)
        {
            // Veritabanı yolunu ve bağlantı string'ini oluştur
            string dbPath = Server.MapPath("~/App_Data/NewsDB.accdb");
            string connectionString = $"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={dbPath}";

            using (OleDbConnection conn = new OleDbConnection(connectionString))
            {
                try
                {
                    conn.Open(); // Bağlantıyı aç

                    // Aynı başlıkta haber var mı kontrol et
                    using (OleDbCommand checkCmd = new OleDbCommand("SELECT COUNT(*) FROM News WHERE Title = ?", conn))
                    {
                        checkCmd.Parameters.AddWithValue("?", news.Title);
                        int count = (int)checkCmd.ExecuteScalar();

                        // Eğer haber yoksa ekle
                        if (count == 0)
                        {
                            using (OleDbCommand insertCmd = new OleDbCommand(
                                "INSERT INTO News (Title, Description, Category, Author, PubDate, ImageUrl) " +
                                "VALUES (?, ?, ?, ?, ?, ?)", conn))
                            {
                                // Parametreleri ekle
                                insertCmd.Parameters.AddWithValue("?", news.Title);
                                insertCmd.Parameters.AddWithValue("?", news.Description);
                                insertCmd.Parameters.AddWithValue("?", news.Category);
                                insertCmd.Parameters.AddWithValue("?", news.Author);
                                insertCmd.Parameters.AddWithValue("?", news.PubDate);
                                insertCmd.Parameters.AddWithValue("?", news.ImageUrl);

                                insertCmd.ExecuteNonQuery(); // Sorguyu çalıştır
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Hata durumunda mesaj göster
                    lblStatus.Text += $"<br/><span style='color:red'>Hata (kayıt): {news.Title} - {ex.Message}</span>";
                    LogError(ex, $"Saving news: {news.Title}"); // Hatayı logla
                }
            }

        }

        // Veritabanındaki tüm haberleri temizleyen metod
        private void ClearDatabase()
        {
            // Veritabanı yolunu ve bağlantı string'ini oluştur
            string dbPath = Server.MapPath("~/App_Data/NewsDB.accdb");
            string connectionString = $"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={dbPath}";

            using (OleDbConnection conn = new OleDbConnection(connectionString))
            {
                try
                {
                    conn.Open(); // Bağlantıyı aç
                    using (OleDbCommand cmd = new OleDbCommand("DELETE FROM News", conn))
                    {
                        // Tüm haberleri sil ve etkilenen satır sayısını al
                        int rowsAffected = cmd.ExecuteNonQuery();
                        // Durum mesajına silinen kayıt sayısını yaz
                        lblStatus.Text += $"<br/><span style='color:blue'>Veritabanı temizlendi: {rowsAffected} kayıt silindi.</span>";
                    }
                }
                catch (Exception ex)
                {
                    // Hata durumunda mesaj göster
                    lblStatus.Text += "<br/><span style='color:red'>Veritabanı temizleme hatası: " + ex.Message + "</span>";
                    LogError(ex, "Clearing database"); // Hatayı logla
                }
            }
        }

        // RSS içeriğini indiren metod
        private string DownloadRssContent(string url)
        {
            using (WebClient client = new WebClient())
            {
                client.Encoding = Encoding.UTF8; // UTF-8 kodlaması
                client.Headers.Add("User-Agent", "Mozilla/5.0"); // User-Agent başlığı
                return client.DownloadString(url); // İçeriği indir ve döndür
            }
        }

        // XML'deki geçersiz karakterleri temizleyen metod
        private string RemoveInvalidXmlChars(string input)
        {
            if (string.IsNullOrEmpty(input)) return input; // Boşsa aynen döndür
            // Geçersiz karakterleri regex ile temizle
            return Regex.Replace(input, @"[\x00-\x08\x0B\x0C\x0E-\x1F]", string.Empty);
        }

        // Metni temizleyen metod (HTML etiketlerini ve fazla boşlukları kaldırır)
        private string CleanText(string text)
        {
            if (string.IsNullOrEmpty(text)) return text; // Boşsa aynen döndür
            text = Regex.Replace(text, "<[^>]*>", string.Empty); // HTML etiketlerini kaldır
            text = HttpUtility.HtmlDecode(text); // HTML varlıklarını çöz
            return Regex.Replace(text, @"\s+", " ").Trim(); // Fazla boşlukları temizle
        }

        // Hataları log dosyasına yazan metod
        private void LogError(Exception ex, string url)
        {
            try
            {
                // Log dosyası yolu
                string logPath = Server.MapPath("~/App_Data/rss_errors.log");
                // Log mesajını oluştur
                string logMessage = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] URL: {url}\nHata: {ex.Message}\nDetay: {ex}\n\n";
                File.AppendAllText(logPath, logMessage); // Dosyaya ekle
            }
            catch { /* Loglama hatasını gözardı et */ }
        }
    }
}
