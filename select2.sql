USE AcikOgretimSinavYonetimi;
GO

SELECT DISTINCT
    o.Ogrenci_ID,
    o.Ad,
    o.Soyad,
    o.TCKimlikNo,
    o.Cinsiyet,
    o.DogumTarihi,
    o.Yas,
    o.Telefon,
    o.Eposta
FROM Ogrenci o
JOIN Ogrenci_Sinav os ON o.Ogrenci_ID = os.Ogrenci_ID
JOIN Sinav_Sinif ss ON os.Sinav_Sinif_ID = ss.Sinav_Sinif_ID
JOIN Sinav s ON ss.Sinav_ID = s.Sinav_ID
WHERE
    s.Sinav_Tarihi = (
        SELECT MAX(Sinav_Tarihi)
        FROM Sinav
    )
    AND os.Geldi_mi = 1

    AND NOT EXISTS (
        SELECT 1
        FROM Ogrenci_Cevap oc
        JOIN Cevap_Havuzu ch ON oc.Cevap_ID = ch.Cevap_ID
        WHERE
            oc.Ogrenci_Sinav_ID = os.Ogrenci_Sinav_ID
            AND ch.Dogru_mu = 0
    )

    AND NOT EXISTS (
        SELECT 1
        FROM Soru_Sirasi ssira
        WHERE
            ssira.Kitapcik_ID = os.Kitapcik_ID
            AND NOT EXISTS (
                SELECT 1
                FROM Ogrenci_Cevap oc2
                JOIN Cevap_Havuzu ch2 ON oc2.Cevap_ID = ch2.Cevap_ID
                WHERE
                    oc2.Ogrenci_Sinav_ID = os.Ogrenci_Sinav_ID
                    AND oc2.Soru_Sirasi_ID = ssira.Soru_Sirasi_ID
                    AND ch2.Dogru_mu = 1
            )
    );