<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewsDetail.aspx.cs" Inherits="NewsApp.NewsDetail" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Haber Detayı | Haber Portalı</title>
    
    <!-- Mobil uyumlu görünüm için -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Google Fonts ve Font Awesome kütüphaneleri -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <!-- Sayfa içi stil tanımlamaları -->
    <style>
        /* Temel renkler ve değişkenler */
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
            --light-color: #ecf0f1;
            --dark-color: #2c3e50;
            --text-color: #333;
            --text-light: #7f8c8d;
        }

        /* Genel sıfırlamalar */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Gövde stilleri */
        body {
            font-family: 'Open Sans', sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: #f9f9f9;
        }

        /* Konteyner */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        /* Üst kısım (header) */
        header {
            background-color: var(--primary-color);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Logo */
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

        /* Haber detay kutusu */
        .news-detail-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 3rem;
        }

        .news-header {
            padding: 2rem;
            border-bottom: 1px solid #eee;
        }

        /* Kategori etiketi */
        .news-category {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            background: var(--secondary-color);
            color: white;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 1rem;
            text-transform: uppercase;
        }

        /* Başlık */
        .news-title {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--dark-color);
            line-height: 1.3;
        }

        /* Meta bilgiler (yazar, tarih) */
        .news-meta {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 1rem;
            color: var(--text-light);
        }

        .news-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .news-meta-item i {
            color: var(--accent-color);
        }

        /* Haber görseli */
        .news-image {
            width: 100%;
            max-height: 500px;
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .news-image img {
            width: 100%;
            height: auto;
            object-fit: cover;
        }

        /* İçerik kısmı */
        .news-content {
            padding: 2rem;
            font-size: 1.1rem;
            line-height: 1.8;
        }

        .news-content p {
            margin-bottom: 1.5rem;
        }

        /* Geri dön butonu */
        .back-button {
            display: inline-block;
            margin-top: 2rem;
            padding: 0.7rem 1.5rem;
            background: var(--secondary-color);
            color: white;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            transition: background 0.3s ease;
        }

        .back-button:hover {
            background: var(--primary-color);
        }

        .back-button i {
            margin-right: 0.5rem;
        }

        /* Alt bilgi (footer) */
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

        /* Sosyal medya ikonları */
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

        /* Mobil uyum için medya sorguları */
        @media (max-width: 768px) {
            .news-title {
                font-size: 1.5rem;
            }

            .news-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .news-header, .news-content {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- ASP.NET form -->
    <form id="form1" runat="server">
        <!-- Üst menü -->
        <header>
            <div class="container header-content">
                <a href="Home.aspx" class="logo">Haber<span>Portalı</span></a>
            </div>
        </header>

        <!-- Ana içerik alanı -->
        <main class="container">
            <div class="news-detail-container">
                <div class="news-header">
                    <!-- Kategori etiketi -->
                    <span class="news-category" id="lblCategory" runat="server"></span>
                    <!-- Başlık -->
                    <h1 id="lblTitle" runat="server" class="news-title"></h1>
                    <!-- Meta bilgiler: yazar ve tarih -->
                    <div class="news-meta">
                        <div class="news-meta-item">
                            <i class="fas fa-user"></i>
                            <span id="lblAuthor" runat="server"></span>
                        </div>
                        <div class="news-meta-item">
                            <i class="far fa-clock"></i>
                            <span id="lblDate" runat="server"></span>
                        </div>
                    </div>
                </div>

                <!-- Haber görseli -->
                <div class="news-image">
                    <img id="imgNews" runat="server" alt="Haber Görseli"
                         onerror="this.src='https://via.placeholder.com/800x450?text=Haber+Resmi'">
                </div>

                <!-- Haber metni ve geri dön butonu -->
                <div class="news-content">
                    <p id="lblDescription" runat="server"></p>
                    <a href="Home.aspx" class="back-button">
                        <i class="fas fa-arrow-left"></i> Haber Listesine Dön
                    </a>
                </div>
            </div>
        </main>

        <!-- Alt bilgi (footer) -->
        <footer>
            <div class="container footer-content">
                <div class="social-links">
                    <!-- Sosyal medya ikonları -->
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
                <p>&copy; 2023 Haber Portalı. Tüm hakları saklıdır.</p>
            </div>
        </footer>
    </form>
</body>
</html>
