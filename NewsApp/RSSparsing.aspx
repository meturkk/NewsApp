<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RSSparsing.aspx.cs" Inherits="NewsApp.RSSparsing" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RSS Haber Çekici | Haber Portalı</title>
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
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .admin-panel {
            background: white;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            padding: 2rem;
        }
        
        .panel-header {
            margin-bottom: 2rem;
            text-align: center;
        }
        
        .panel-header h1 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .panel-header p {
            color: var(--text-light);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-control {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
            font-size: 1rem;
        }
        
        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            cursor: pointer;
        }
        
        .checkbox-label input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }
        
        .btn {
            background-color: var(--secondary-color);
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn:hover {
            background-color: var(--primary-color);
        }
        
        .btn i {
            font-size: 0.9rem;
        }
        
        .status-message {
            margin-top: 1.5rem;
            padding: 1rem;
            border-radius: 4px;
            background-color: #f8f9fa;
            border-left: 4px solid var(--secondary-color);
        }
        
        .status-message.success {
            border-left-color: #28a745;
            background-color: #e6f7ee;
        }
        
        .status-message.error {
            border-left-color: #dc3545;
            background-color: #fce8e8;
        }
        
        .status-message.warning {
            border-left-color: #ffc107;
            background-color: #fff8e6;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 1.5rem;
            color: var(--secondary-color);
            text-decoration: none;
            font-weight: 600;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            .admin-panel {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Ana form -->
    <form id="form1" runat="server">
        <div class="container">
            <!-- Admin panel kutusu -->
            <div class="admin-panel">
                <!-- Panel başlık alanı -->
                <div class="panel-header">
                    <h1><i class="fas fa-rss"></i> RSS Haber Çekici</h1>
                    <p>Haber kaynaklarından son haberleri çekin ve veritabanına kaydedin</p>
                </div>
                
                <!-- Checkbox form grubu -->
                <div class="form-group">
                    <label class="checkbox-label">
                        <!-- Mevcut haberleri temizleme checkbox'ı -->
                        <asp:CheckBox ID="chkClearExisting" runat="server" />
                        <span>Mevcut haberleri temizle</span>
                    </label>
                    <!-- Açıklama metni -->
                    <p class="help-text" style="color: var(--text-light); font-size: 0.9rem;">
                        İşaretlenirse, veritabanındaki tüm mevcut haberler silinecek ve yeni haberler eklenecektir.
                    </p>
                </div>
                
                <!-- Haber çekme butonu -->
                <asp:Button ID="btnParse" runat="server" Text="Haberleri Çek" OnClick="btnParse_Click" CssClass="btn" />
                
                <!-- Durum mesajı alanı -->
                <div class="status-message" id="statusContainer" runat="server" visible="false">
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                </div>
                
                <!-- Ana sayfaya dönüş bağlantısı -->
                <a href="Home.aspx" class="back-link"><i class="fas fa-arrow-left"></i> Ana Sayfaya Dön</a>
            </div>
        </div>
    </form>
</body>
</html>
