--database oluştur
CREATE DATABASE KitapEvim;
GO

--database kullan
USE KitapEvim;
GO

-- Category tablosu oluşturuluyor
CREATE TABLE dbo.Category (
    id INT IDENTITY(1,1) PRIMARY KEY,           -- Otomatik artan ID
    name NVARCHAR(255) NOT NULL                 -- Kategori ismi
);
GO

-- REklam slider için tablosu oluşturuluyor
CREATE TABLE dbo.Add (
    id INT IDENTITY(1,1) PRIMARY KEY,           -- Otomatik artan ID
    title NVARCHAR(255) NOT NULL,               -- Kitap adı
    description NVARCHAR(MAX) NULL,             -- Kitap açıklaması
    image_path NVARCHAR(500) NULL,              -- Görsel yolu
    order_number INT NOT NULL                   -- Sıra numarası
);
GO

-- Kullanıcılar için tablo oluşturuluyor
CREATE TABLE dbo.Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,           -- Otomatik artan Id sütunu
    Email NVARCHAR(255) NOT NULL UNIQUE,        -- Kullanıcı Email bilgisi (Benzersiz)
    Password VARBINARY(64) NOT NULL             -- Hashlenmiş şifre (64 byte uzunluğunda)
);
GO

-- Kitaplar için tablo oluşturuluyor
CREATE TABLE dbo.Book (
    id INT IDENTITY(1,1) PRIMARY KEY,           -- Otomatik artan ID
    cover_image VARCHAR(500),                   -- Kapak fotoğrafının yolu (Genişletilmiş)
    title VARCHAR(255) NOT NULL,                -- Kitap adı
    description TEXT,                           -- Kitap açıklaması
    difficulty_level VARCHAR(50),               -- Zorluk seviyesi
    average_reading_time FLOAT,                 -- Ortalama okuma süresi (saat)
    price INT NOT NULL,                         -- Fiyat
    discount INT DEFAULT 0,                     -- İndirim (varsayılan 0)
    is_active BIT DEFAULT 1,                    -- Aktiflik durumu (1: aktif, 0: pasif)
    pdf_file VARCHAR(500),                      -- PDF dosya yolu (Genişletilmiş)
    sold_count INT DEFAULT 0,                   -- Satılan kitap adedi
    category_id INT,                            -- Kategori ID'si (Foreign Key)
    CONSTRAINT FK_Books_Category FOREIGN KEY (category_id) REFERENCES dbo.Category(id) -- Kategori tablosuna Foreign Key
);
GO
