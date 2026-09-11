USE AcikOgretimSinavYonetimi;
GO

SELECT
    d.Kod AS Ders_Kodu,
    i.Il_Adi,
    COUNT(DISTINCT o.Ogrenci_ID) AS Ogrenci_Sayisi
FROM Ders_Kaydi dk
JOIN Ders d ON dk.Ders_ID = d.Ders_ID
JOIN Kitapcik k ON dk.Vize_Kitapcik_ID = k.Kitapcik_ID
JOIN Sinav s ON k.Sinav_ID = s.Sinav_ID
JOIN Donem_Kaydi donem ON dk.Donem_Kaydi_ID = donem.Donem_Kaydi_ID
JOIN Ogrenci_Bolum ob ON donem.Ogrenci_Bolum_ID = ob.Ogrenci_Bolum_ID
JOIN Ogrenci o ON ob.Ogrenci_ID = o.Ogrenci_ID
JOIN Ilce ilce ON o.Ilce_ID = ilce.Ilce_ID
JOIN Il i ON ilce.Il_ID = i.Il_ID
WHERE
    d.Kod = 'BIL101'
    AND dk.Vize_Notu IS NOT NULL
    AND s.Sinav_ID = (
        SELECT TOP 1 s2.Sinav_ID
        FROM Sinav s2
        JOIN Ders d2 ON s2.Ders_ID = d2.Ders_ID
        WHERE d2.Kod = 'BIL101'
        ORDER BY s2.Sinav_Tarihi DESC, s2.Sinav_ID DESC
    )
    AND dk.Vize_Notu > (
        SELECT AVG(CAST(dk2.Vize_Notu AS FLOAT))
        FROM Ders_Kaydi dk2
        JOIN Ders d3 ON dk2.Ders_ID = d3.Ders_ID
        JOIN Kitapcik k2 ON dk2.Vize_Kitapcik_ID = k2.Kitapcik_ID
        JOIN Sinav s3 ON k2.Sinav_ID = s3.Sinav_ID
        JOIN Donem_Kaydi donem2 ON dk2.Donem_Kaydi_ID = donem2.Donem_Kaydi_ID
        JOIN Ogrenci_Bolum ob2 ON donem2.Ogrenci_Bolum_ID = ob2.Ogrenci_Bolum_ID
        JOIN Ogrenci o2 ON ob2.Ogrenci_ID = o2.Ogrenci_ID
        JOIN Ilce ilce2 ON o2.Ilce_ID = ilce2.Ilce_ID
        WHERE
            d3.Kod = 'BIL101'
            AND ilce2.Il_ID = i.Il_ID
            AND dk2.Vize_Notu IS NOT NULL
            AND s3.Sinav_Tarihi >= DATEADD(YEAR, -3, s.Sinav_Tarihi)
            AND s3.Sinav_Tarihi < s.Sinav_Tarihi
    )
GROUP BY d.Kod, i.Il_Adi
ORDER BY Ogrenci_Sayisi DESC, i.Il_Adi ASC;