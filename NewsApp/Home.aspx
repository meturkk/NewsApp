<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="NewsApp.Home" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Haber Portalı</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
            --light-color: #ecf0f1;
            --dark-color: #2c3e50;
            --text-color: #333;
            --text-light: #7f8c8d;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Open Sans', sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: #f9f9f9;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }
        
        header {
            background-color: var(--primary-color);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            font-family: 'Roboto', sans-serif;
            color: white;
            text-decoration: none;
        }
        
        .logo span {
            color: var(--accent-color);
        }
        
        .category-filter {
            margin: 2rem 0;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .category-filter label {
            font-weight: 600;
            color: var(--dark-color);
        }
        
        #ddlCategories {
            padding: 0.5rem 1rem;
            border: 2px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
            font-size: 1rem;
            min-width: 200px;
            background-color: white;
        }
        
        .news-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .news-item {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .news-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .news-image {
            height: 200px;
            overflow: hidden;
        }
        
        .news-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .news-item:hover .news-image img {
            transform: scale(1.05);
        }
        
        .news-content {
            padding: 1.5rem;
        }
        
        .category-label {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            background: var(--secondary-color);
            color: white;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 0.8rem;
            text-transform: uppercase;
        }
        
        .news-title {
            font-size: 1.3rem;
            margin-bottom: 0.8rem;
            line-height: 1.4;
        }
        
        .news-title a {
            color: var(--dark-color);
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .news-title a:hover {
            color: var(--accent-color);
        }
        
        .news-desc {
            color: var(--text-light);
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .news-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
            color: var(--text-light);
        }
        
        .news-date i {
            margin-right: 5px;
            color: var(--accent-color);
        }
        
        .read-more {
            color: var(--secondary-color);
            font-weight: 600;
            text-decoration: none;
            font-size: 0.9rem;
        }
        
        .read-more:hover {
            text-decoration: underline;
        }
        
        .no-news {
            text-align: center;
            padding: 2rem;
            grid-column: 1 / -1;
            color: var(--text-light);
        }
        
        footer {
            background-color: var(--primary-color);
            color: white;
            padding: 2rem 0;
            text-align: center;
            margin-top: 3rem;
        }
        
        .footer-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }
        
        .social-links {
            display: flex;
            gap: 1rem;
        }
        
        .social-links a {
            color: white;
            font-size: 1.2rem;
            transition: color 0.3s ease;
        }
        
        .social-links a:hover {
            color: var(--accent-color);
        }
        
        @media (max-width: 768px) {
            .news-container {
                grid-template-columns: 1fr;
            }
            
            .header-content {
                flex-direction: column;
                gap: 1rem;
            }
            
            .category-filter {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <!-- Ana form -->
    <form id="form1" runat="server">
        <!-- Üst bilgi (header) -->
        <header>
            <div class="container header-content">
                <!-- Logo ve site adı -->
                <a href="Home.aspx" class="logo">Haber<span>Portalı</span></a>
                <!-- Arama kutusu (ileride eklenecek) -->
                <div class="search-box">
                    <!-- Arama kutusu eklenebilir -->
                </div>
            </div>
        </header>
        
        <!-- Ana içerik -->
        <main class="container">
            <!-- Kategori filtreleme alanı -->
            <div class="category-filter">
                <label for="ddlCategories">Kategori:</label>
                <!-- Kategori dropdown listesi -->
                <asp:DropDownList ID="ddlCategories" runat="server" AutoPostBack="true" 
                    OnSelectedIndexChanged="ddlCategories_SelectedIndexChanged" CssClass="form-control">
                    <asp:ListItem Text="Tüm Kategoriler" Value="all"></asp:ListItem>
                </asp:DropDownList>
            </div>
            
            <!-- Haber listesi -->
            <div class="news-container">
                <!-- Repeater kontrolü ile haber listesi -->
                <asp:Repeater ID="rptNews" runat="server">
                    <ItemTemplate>
                        <!-- Tek bir haber öğesi -->
                        <div class="news-item">
                            <!-- Haber resmi -->
                            <div class="news-image">
                                <!-- Resim URL'si yoksa placeholder göster -->
                                <img src='<%# GetImageUrl(Eval("ImageUrl")) %>' alt='<%# Eval("Title") %>' onerror="this.src='https://via.placeholder.com/350x200?text=Haber+Resmi'">
                            </div>
                            <!-- Haber içeriği -->
                            <div class="news-content">
                                <!-- Kategori etiketi -->
                                <span class="category-label"><%# Eval("Category") %></span>
                                <!-- Haber başlığı -->
                                <h3 class="news-title">
                                    <a href='NewsDetail.aspx?id=<%# Eval("NewsID") %>'><%# Eval("Title") %></a>
                                </h3>
                                <!-- Haber açıklaması (kısaltılmış) -->
                                <p class="news-desc"><%# TruncateDescription(Eval("Description").ToString()) %></p>
                                <!-- Haber meta bilgileri (tarih ve okuma linki) -->
                                <div class="news-meta">
                                    <span class="news-date"><i class="far fa-clock"></i> <%# FormatDate(Eval("PubDate")) %></span>
                                    <a href='NewsDetail.aspx?id=<%# Eval("NewsID") %>' class="read-more">Devamını oku <i class="fas fa-arrow-right"></i></a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <!-- Haber bulunamadı mesajı (gerekirse gösterilir) -->
                <asp:Label ID="lblNoNews" runat="server" CssClass="no-news" Text="Bu kategoride haber bulunamadı." Visible="false"></asp:Label>
            </div>
        </main>
        
        <!-- Alt bilgi (footer) -->
        <footer>
            <div class="container footer-content">
                <!-- Sosyal medya linkleri -->
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
                <!-- Telif hakkı bilgisi -->
                <p>&copy; 2023 Haber Portalı. Tüm hakları saklıdır.</p>
            </div>
        </footer>
    </form>
</body>
</html>