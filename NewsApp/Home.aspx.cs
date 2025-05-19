using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NewsApp
{
    public partial class Home : System.Web.UI.Page
    {
        // Sayfa yüklendiğinde çalışır
        protected void Page_Load(object sender, EventArgs e)
        {
            // Sayfa ilk kez yükleniyorsa (PostBack değilse)
            if (!IsPostBack)
            {
                LoadCategories(); // Kategori listesini yükle
                LoadNews();       // Haberleri yükle
            }
        }

        // Kategori listesini DropDownList'e yükler
        private void LoadCategories()
        {
            // Veritabanı dosya yolunu belirle
            string dbPath = Server.MapPath("~/App_Data/NewsDB.accdb");
            // Bağlantı cümlesini oluştur
            string connectionString = $"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={dbPath}";

            using (OleDbConnection conn = new OleDbConnection(connectionString))
            {
                try
                {
                    conn.Open(); // Bağlantıyı aç
                    // Kategorileri sorgula
                    string query = "SELECT DISTINCT Category FROM News ORDER BY Category";

                    OleDbCommand cmd = new OleDbCommand(query, conn);
                    OleDbDataReader reader = cmd.ExecuteReader();

                    // Her bir kategoriyi DropDownList'e ekle
                    while (reader.Read())
                    {
                        ddlCategories.Items.Add(new ListItem(reader["Category"].ToString(), reader["Category"].ToString()));
                    }
                }
                catch (Exception ex)
                {
                    // Hata loglama yapılabilir
                    // örn: Logger.Log(ex.Message);
                }
            }
        }

        // Kategori seçildiğinde haberleri filtrele
        protected void ddlCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadNews(); // Seçilen kategoriye göre haberleri yeniden yükle
        }

        // Haberleri veritabanından yükler
        private void LoadNews()
        {
            // Seçilen kategoriyi al
            string selectedCategory = ddlCategories.SelectedValue;
            string dbPath = Server.MapPath("~/App_Data/NewsDB.accdb");
            string connectionString = $"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={dbPath}";

            using (OleDbConnection conn = new OleDbConnection(connectionString))
            {
                try
                {
                    conn.Open(); // Bağlantıyı aç
                    string query = "SELECT * FROM News ";

                    // Eğer tüm kategoriler seçili değilse filtre uygula
                    if (selectedCategory != "all")
                    {
                        query += "WHERE Category = @Category ";
                    }

                    query += "ORDER BY PubDate DESC"; // En yeni haberler üstte

                    OleDbCommand cmd = new OleDbCommand(query, conn);

                    // Parametre olarak kategori değerini ekle
                    if (selectedCategory != "all")
                    {
                        cmd.Parameters.AddWithValue("@Category", selectedCategory);
                    }

                    OleDbDataReader reader = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(reader); // Verileri tabloya yükle

                    rptNews.DataSource = dt; // Repeater'a veri kaynağını ata
                    rptNews.DataBind();      // Bağla

                    // Eğer haber yoksa bilgi etiketi gösterilsin
                    lblNoNews.Visible = dt.Rows.Count == 0;
                }
                catch (Exception ex)
                {
                    // Hata loglama yapılabilir
                    // örn: Logger.Log(ex.Message);
                }
            }
        }

        // Açıklamayı 150 karakterle sınırla
        public string TruncateDescription(string description)
        {
            if (string.IsNullOrEmpty(description)) return string.Empty;

            // Eğer açıklama uzun ise, 150 karakterden kes ve "..." ekle
            if (description.Length > 150)
            {
                return description.Substring(0, 150) + "...";
            }
            return description;
        }

        // Yayın tarihini biçimlendir (dd.MM.yyyy HH:mm)
        public string FormatDate(object dateObj)
        {
            if (dateObj != null && DateTime.TryParse(dateObj.ToString(), out DateTime date))
            {
                return date.ToString("dd.MM.yyyy HH:mm");
            }
            return string.Empty;
        }

        // Resim URL'si yoksa varsayılan bir görsel döndür
        public string GetImageUrl(object imageUrl)
        {
            if (imageUrl == null || string.IsNullOrEmpty(imageUrl.ToString()))
            {
                // Resim yoksa placeholder döndür
                return "https://via.placeholder.com/350x200?text=Haber+Resmi";
            }
            return imageUrl.ToString(); // Aksi halde mevcut URL'yi döndür
        }
    }
}
