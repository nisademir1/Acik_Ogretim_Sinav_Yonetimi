USE AcikOgretimSinavYonetimi;
GO

CREATE TABLE Il (
    Il_ID INT PRIMARY KEY,
    Il_Adi NVARCHAR(50) NOT NULL
);

CREATE TABLE Ilce (
    Ilce_ID INT PRIMARY KEY,
    Ilce_Adi NVARCHAR(50) NOT NULL,
    Il_ID INT NOT NULL,
    FOREIGN KEY (Il_ID) REFERENCES Il(Il_ID)
);

CREATE TABLE Bolum (
    Bolum_ID INT PRIMARY KEY,
    Ad NVARCHAR(100) NOT NULL,
    Aciklama NVARCHAR(255) NULL,
    Aktiflik_Durumu BIT NOT NULL,
    Acilis_Tarihi DATE NULL
);

CREATE TABLE Ogrenci (
    Ogrenci_ID INT PRIMARY KEY,
    TCKimlikNo CHAR(11) NOT NULL,
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Cinsiyet NVARCHAR(10) NOT NULL,
    DogumTarihi DATE NOT NULL,
    Yas AS DATEDIFF(YEAR, DogumTarihi, GETDATE()),
    Telefon NVARCHAR(20) NULL,
    Eposta NVARCHAR(100) NULL,
    Sifre NVARCHAR(50) NOT NULL,
    Ilce_ID INT NOT NULL,
    AdresAciklamasi NVARCHAR(255) NULL,
    FOREIGN KEY (Ilce_ID) REFERENCES Ilce(Ilce_ID)
);

CREATE TABLE Ogrenci_Bolum (
    Ogrenci_Bolum_ID INT PRIMARY KEY,
    Ogrenci_ID INT NOT NULL,
    Bolum_ID INT NOT NULL,
    Kayit_Tarihi DATE NOT NULL,
    Mezuniyet_Tarihi DATE NULL,
    Genel_Not_Ortalamasi DECIMAL(5,2) NULL,
    Aktif_mi BIT NOT NULL,
    FOREIGN KEY (Ogrenci_ID) REFERENCES Ogrenci(Ogrenci_ID),
    FOREIGN KEY (Bolum_ID) REFERENCES Bolum(Bolum_ID)
);

CREATE TABLE Donem_Kaydi (
    Donem_Kaydi_ID INT PRIMARY KEY,
    Ogrenci_Bolum_ID INT NOT NULL,
    Donem_No INT NOT NULL,
    Akademik_Yil NVARCHAR(20) NOT NULL,
    Kayit_Tarihi DATE NOT NULL,
    Toplam_Odenmesi_Gereken_Ucret DECIMAL(10,2) NOT NULL,
    Toplam_Odenen_Ucret DECIMAL(10,2) NULL,
    Alinan_Ders_Sayisi INT NULL,
    Alinan_Kredi INT NULL,
    Alinan_AKTS INT NULL,
    Tamamlanan_Ders_Sayisi INT NULL,
    Tamamlanan_Kredi INT NULL,
    Tamamlanan_AKTS INT NULL,
    Donem_Not_Ortalamasi DECIMAL(5,2) NULL,
    Genel_Not_Ortalamasi DECIMAL(5,2) NULL,
    FOREIGN KEY (Ogrenci_Bolum_ID) REFERENCES Ogrenci_Bolum(Ogrenci_Bolum_ID)
);

CREATE TABLE Ders (
    Ders_ID INT PRIMARY KEY,
    Kod NVARCHAR(20) NOT NULL,
    Ad NVARCHAR(100) NOT NULL,
    Aciklama NVARCHAR(255) NULL,
    Kredi INT NOT NULL,
    AKTS INT NOT NULL,
    Donem INT NOT NULL,
    Ders_Kayit_Ucreti DECIMAL(10,2) NOT NULL,
    Bolum_ID INT NOT NULL,
    FOREIGN KEY (Bolum_ID) REFERENCES Bolum(Bolum_ID)
);

CREATE TABLE Sinav (
    Sinav_ID INT PRIMARY KEY,
    Ders_ID INT NOT NULL,
    Sinav_Turu NVARCHAR(20) NOT NULL,
    Sinav_Tarihi DATETIME NOT NULL,
    Aciklama NVARCHAR(255) NULL,
    FOREIGN KEY (Ders_ID) REFERENCES Ders(Ders_ID)
);

CREATE TABLE Kitapcik (
    Kitapcik_ID INT PRIMARY KEY,
    Kitapcik_No NVARCHAR(50) NOT NULL,
    Grup NVARCHAR(5) NOT NULL,
    Sinav_ID INT NOT NULL,
    FOREIGN KEY (Sinav_ID) REFERENCES Sinav(Sinav_ID)
);

CREATE TABLE Ders_Kaydi (
    Ders_Kaydi_ID INT PRIMARY KEY,
    Ders_ID INT NOT NULL,
    Donem_Kaydi_ID INT NOT NULL,
    Alindigi_Donem INT NOT NULL,
    Ucret DECIMAL(10,2) NOT NULL,
    Vize_Kitapcik_ID INT NULL,
    Vize_Notu INT NULL,
    Vize_Orani INT NULL,
    Final_Kitapcik_ID INT NULL,
    Final_Notu INT NULL,
    Final_Orani INT NULL,
    Ortalama AS ((Vize_Notu * 0.4) + (Final_Notu * 0.6)),
    Harf_Notu NVARCHAR(5) NULL,
    FOREIGN KEY (Ders_ID) REFERENCES Ders(Ders_ID),
    FOREIGN KEY (Donem_Kaydi_ID) REFERENCES Donem_Kaydi(Donem_Kaydi_ID),
    FOREIGN KEY (Vize_Kitapcik_ID) REFERENCES Kitapcik(Kitapcik_ID),
    FOREIGN KEY (Final_Kitapcik_ID) REFERENCES Kitapcik(Kitapcik_ID)
);

CREATE TABLE Okul (
    Okul_ID INT PRIMARY KEY,
    Kod NVARCHAR(20) NOT NULL,
    Ad NVARCHAR(100) NOT NULL,
    Ilce_ID INT NOT NULL,
    Adres NVARCHAR(255) NULL,
    Telefon NVARCHAR(20) NULL,
    Sinif_Sayisi INT NOT NULL,
    Toplam_Kapasite INT NOT NULL,
    Aktiflik_Durumu BIT NOT NULL,
    FOREIGN KEY (Ilce_ID) REFERENCES Ilce(Ilce_ID)
);

CREATE TABLE Sinif (
    Sinif_ID INT PRIMARY KEY,
    Kod NVARCHAR(20) NOT NULL,
    Kapasite INT NOT NULL,
    Aktiflik_Durumu BIT NOT NULL,
    Okul_ID INT NOT NULL,
    FOREIGN KEY (Okul_ID) REFERENCES Okul(Okul_ID)
);

CREATE TABLE Sinav_Sinif (
    Sinav_Sinif_ID INT PRIMARY KEY,
    Sinav_ID INT NOT NULL,
    Sinif_ID INT NOT NULL,
    FOREIGN KEY (Sinav_ID) REFERENCES Sinav(Sinav_ID),
    FOREIGN KEY (Sinif_ID) REFERENCES Sinif(Sinif_ID)
);

CREATE TABLE Ogrenci_Sinav (
    Ogrenci_Sinav_ID INT PRIMARY KEY,
    Ogrenci_ID INT NOT NULL,
    Geldi_mi BIT NOT NULL,
    Sinav_Sinif_ID INT NOT NULL,
    Kitapcik_ID INT NULL,
    FOREIGN KEY (Ogrenci_ID) REFERENCES Ogrenci(Ogrenci_ID),
    FOREIGN KEY (Sinav_Sinif_ID) REFERENCES Sinav_Sinif(Sinav_Sinif_ID),
    FOREIGN KEY (Kitapcik_ID) REFERENCES Kitapcik(Kitapcik_ID)
);

CREATE TABLE Soru_Havuzu (
    Soru_ID INT PRIMARY KEY,
    Soru_Metni NVARCHAR(255) NOT NULL,
    Ders_ID INT NOT NULL,
    FOREIGN KEY (Ders_ID) REFERENCES Ders(Ders_ID)
);

CREATE TABLE Cevap_Havuzu (
    Cevap_ID INT PRIMARY KEY,
    Cevap_Metni NVARCHAR(255) NOT NULL,
    Dogru_mu BIT NOT NULL,
    Soru_ID INT NOT NULL,
    FOREIGN KEY (Soru_ID) REFERENCES Soru_Havuzu(Soru_ID)
);

CREATE TABLE Soru_Sirasi (
    Soru_Sirasi_ID INT PRIMARY KEY,
    Kitapcik_ID INT NOT NULL,
    Soru_ID INT NOT NULL,
    Sorunun_Sinavdaki_Sirasi INT NOT NULL,
    FOREIGN KEY (Kitapcik_ID) REFERENCES Kitapcik(Kitapcik_ID),
    FOREIGN KEY (Soru_ID) REFERENCES Soru_Havuzu(Soru_ID)
);

CREATE TABLE Kitapcik_Cevap_Sirasi (
    Kitapcik_Cevap_Sirasi_ID INT PRIMARY KEY,
    Soru_Sirasi_ID INT NOT NULL,
    Cevap_ID INT NOT NULL,
    Secenek_Sirasi INT NOT NULL,
    FOREIGN KEY (Soru_Sirasi_ID) REFERENCES Soru_Sirasi(Soru_Sirasi_ID),
    FOREIGN KEY (Cevap_ID) REFERENCES Cevap_Havuzu(Cevap_ID)
);

CREATE TABLE Ogrenci_Cevap (
    Ogrenci_Cevap_ID INT PRIMARY KEY,
    Ogrenci_Sinav_ID INT NOT NULL,
    Soru_Sirasi_ID INT NOT NULL,
    Cevap_ID INT NOT NULL,
    FOREIGN KEY (Ogrenci_Sinav_ID) REFERENCES Ogrenci_Sinav(Ogrenci_Sinav_ID),
    FOREIGN KEY (Soru_Sirasi_ID) REFERENCES Soru_Sirasi(Soru_Sirasi_ID),
    FOREIGN KEY (Cevap_ID) REFERENCES Cevap_Havuzu(Cevap_ID)
);

CREATE TABLE Personel (
    Personel_ID INT PRIMARY KEY,
    TC_Kimlik_No CHAR(11) NOT NULL,
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Telefon NVARCHAR(20) NULL,
    E_posta NVARCHAR(100) NULL,
    Sifre NVARCHAR(50) NOT NULL,
    Ilce_ID INT NOT NULL,
    Adres NVARCHAR(255) NULL,
    Kurum_Adi NVARCHAR(100) NULL,
    Unvan NVARCHAR(50) NOT NULL,
    IBAN NVARCHAR(34) NULL,
    FOREIGN KEY (Ilce_ID) REFERENCES Ilce(Ilce_ID)
);

CREATE TABLE Personel_Gorev (
    Personel_Gorev_ID INT PRIMARY KEY,
    Personel_ID INT NOT NULL,
    Sinav_Sinif_ID INT NOT NULL,
    Gorev_Turu NVARCHAR(50) NOT NULL,
    Geldi_mi BIT NOT NULL,
    FOREIGN KEY (Personel_ID) REFERENCES Personel(Personel_ID),
    FOREIGN KEY (Sinav_Sinif_ID) REFERENCES Sinav_Sinif(Sinav_Sinif_ID)
);