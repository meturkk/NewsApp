using System;
using System.Data.OleDb;
using System.Web.UI;

namespace NewsApp
{
    public partial class NewsDetail : System.Web.UI.Page
    {
        // Sayfa yüklendiğinde çalışır
        protected void Page_Load(object sender, EventArgs e)
        {
            // İlk yükleme ise (postback değilse)
            if (!IsPostBack)
            {
                // URL'den gelen haber ID'sini al
                string idStr = Request.QueryString["id"];

                // ID boş değilse ve geçerli bir sayıysa
                if (!string.IsNullOrEmpty(idStr) && int.TryParse(idStr, out int id))
                {
                    // Haberin detaylarını yükle
                    LoadNewsDetail(id);
                }
                else
                {
                    // ID geçersizse kullanıcıya bilgi ver
                    lblTitle.InnerText = "Haber bulunamadı.";
                }
            }
        }

        // Belirtilen ID'ye sahip haberin detaylarını veritabanından çekip ekrana yansıtır
        private void LoadNewsDetail(int id)
        {
            // Veritabanı dosyasının fiziksel yolunu al
            string dbPath = Server.MapPath("~/App_Data/NewsDB.accdb");

            // OleDb bağlantı cümlesi
            string connectionString = $"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={dbPath}";

            // Bağlantı nesnesi oluştur
            using (OleDbConnection conn = new OleDbConnection(connectionString))
            {
                conn.Open(); // Bağlantıyı aç

                // Parametreli SQL sorgusu ile güvenli şekilde haber bilgisi alınır
                string query = "SELECT * FROM News WHERE NewsID = ?";
                OleDbCommand cmd = new OleDbCommand(query, conn);
                cmd.Parameters.AddWithValue("?", id); // Parametreye ID değeri atanır

                OleDbDataReader reader = cmd.ExecuteReader(); // Sorgu çalıştırılır

                // Veri varsa alanlara aktarılır
                if (reader.Read())
                {
                    // Başlık, kategori, yazar bilgilerini göster
                    lblTitle.InnerText = reader["Title"].ToString();
                    lblCategory.InnerText = reader["Category"].ToString();
                    lblAuthor.InnerText = reader["Author"].ToString();

                    // Yayın tarihi varsa uygun formatta göster
                    if (DateTime.TryParse(reader["PubDate"].ToString(), out DateTime pubDate))
                    {
                        lblDate.InnerText = pubDate.ToString("dd.MM.yyyy HH:mm");
                    }
                    else
                    {
                        lblDate.InnerText = reader["PubDate"].ToString(); // Format bozulursa orijinal hali gösterilir
                    }

                    // Açıklama yazısı ve resim yolu gösterilir
                    lblDescription.InnerText = reader["Description"].ToString();

                    // Resim URL'si boşsa varsayılan görsel kullanılır
                    imgNews.Src = string.IsNullOrEmpty(reader["ImageUrl"].ToString()) ?
                        "https://via.placeholder.com/800x450?text=Haber+Resmi" :
                        reader["ImageUrl"].ToString();
                }
                else
                {
                    // Eğer haber bulunamazsa kullanıcı bilgilendirilir
                    lblTitle.InnerText = "Haber bulunamadı.";
                }

                reader.Close(); // Reader kapatılır
                conn.Close();   // Bağlantı kapatılır
            }
        }
    }
}
