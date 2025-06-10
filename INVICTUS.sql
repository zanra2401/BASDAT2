DROP DATABASE INVICTUS;

CREATE DATABASE INVICTUS;

USE INVICTUS;

CREATE TABLE KATEGORI_PRODUK (
    ID_Kategori VARCHAR(50) PRIMARY KEY NOT NULL,
    NamaKategori VARCHAR(100) NOT NULL
);

CREATE TABLE PEMASOK (
    ID_Pemasok VARCHAR(50) PRIMARY KEY NOT NULL,
    NamaPemasok VARCHAR(100) NOT NULL,
    AlamatPemasok TEXT NOT NULL,
    NoTeleponPemasok VARCHAR(50)
);

CREATE TABLE PENGGUNA (
    ID_Pengguna VARCHAR(50) PRIMARY KEY NOT NULL,
    NamaLengkap VARCHAR(100) NOT NULL,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Jabatan_Karyawan ENUM('KASIR', 'STAF OPERASIONAL', 'ADMIN', 'MANAGER')
);

CREATE TABLE LOKASI_PENYIMPANAN (
    ID_Lokasi VARCHAR(50) PRIMARY KEY NOT NULL,
    TipeLokasi VARCHAR(50)
);

CREATE TABLE PRODUK (
    ID_Produk VARCHAR(50) PRIMARY KEY NOT NULL,
    NamaProduk VARCHAR(100) NOT NULL,
    Merek VARCHAR(100),
    ID_Kategori VARCHAR(50) NOT NULL,
    HargaJual DECIMAL(10,2) NOT NULL,
    StokSaatIni INT DEFAULT 0,

    FOREIGN KEY (ID_Kategori) REFERENCES KATEGORI_PRODUK(ID_Kategori)
);

-- Tabel Penghubung Inventori (Stok per Lokasi)

CREATE TABLE INVENTORI_LOKASI (
    ID_InventoriLokasi VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Lokasi VARCHAR(50) NOT NULL,
    ID_Produk VARCHAR(50) NOT NULL,
    StokDiLokasi INT NOT NULL DEFAULT 0,
    TanggalUpdateStok DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (ID_Lokasi) REFERENCES LOKASI_PENYIMPANAN(ID_Lokasi),
    FOREIGN KEY (ID_Produk) REFERENCES PRODUK(ID_Produk)
);

-- Tabel Transaksi Pemesanan (Purchase Order)

CREATE TABLE PO_HEADER (
    ID_Pemesanan VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Pemasok VARCHAR(50) NOT NULL,
    ID_Pengguna VARCHAR(50) NOT NULL,
    TanggalPemesanan DATETIME DEFAULT CURRENT_TIMESTAMP,
    TanggalEstimasiSampai DATETIME,
    StatusPemesanan ENUM('DIBUAT', 'DISETUJUI', 'SELESAI PARSIAL', 'SELESAI', 'DIBATALKAN') NOT NULL,
    HargaTotal DECIMAL(15,2) NOT NULL,
    Catatan TEXT,

    FOREIGN KEY (ID_Pemasok) REFERENCES PEMASOK(ID_Pemasok),
    FOREIGN KEY (ID_Pengguna) REFERENCES PENGGUNA(ID_Pengguna)
);

CREATE TABLE PO_DETAIL (
    ID_PemesananDetail VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Pemesanan VARCHAR(50) NOT NULL,
    ID_Produk VARCHAR(50) NOT NULL,
    JumlahDipesan INT NOT NULL,
    JumlahDiterima INT DEFAULT 0,
    HargaSatuan DECIMAL(10,2) NOT NULL,
    HargaSubTotal DECIMAL(15,2) NOT NULL,

    FOREIGN KEY (ID_Pemesanan) REFERENCES PO_HEADER(ID_Pemesanan),
    FOREIGN KEY (ID_Produk) REFERENCES PRODUK(ID_Produk)
);

-- Tabel Transaksi Penerimaan Barang (Goods Receipt)

CREATE TABLE PENERIMAAN_HEADER (
    ID_Penerimaan VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Pemesanan VARCHAR(50),
    ID_Pengguna VARCHAR(50) NOT NULL,
    TanggalTerima DATETIME DEFAULT CURRENT_TIMESTAMP,
    Catatan TEXT,

    FOREIGN KEY (ID_Pemesanan) REFERENCES PO_HEADER(ID_Pemesanan),
    FOREIGN KEY (ID_Pengguna) REFERENCES PENGGUNA(ID_Pengguna)
);

CREATE TABLE PENERIMAAN_DETAIL (
    ID_PenerimaanDetail VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Penerimaan VARCHAR(50) NOT NULL,
    ID_Produk VARCHAR(50) NOT NULL,
    ID_Lokasi VARCHAR(50) NOT NULL,
    JumlahDiterima INT NOT NULL,
    status_detail ENUM('DITERIMA', 'DIBATALKAN', 'DIPESAN') DEFAULT 'DIPESAN'

    FOREIGN KEY (ID_Penerimaan) REFERENCES PENERIMAAN_HEADER(ID_Penerimaan),
    FOREIGN KEY (ID_Produk) REFERENCES PRODUK(ID_Produk),
    FOREIGN KEY (ID_Lokasi) REFERENCES LOKASI_PENYIMPANAN(ID_Lokasi)
);

-- Tabel Transaksi Penjualan

CREATE TABLE PENJUALAN_HEADER (
    ID_Penjualan VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Pengguna VARCHAR(50) NOT NULL,
    TanggalPenjualan DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalHargaJual DECIMAL(15,2) NOT NULL,
    TotalJumlahProduk INT NOT NULL,

    FOREIGN KEY (ID_Pengguna) REFERENCES PENGGUNA(ID_Pengguna)
);

CREATE TABLE PENJUALAN_DETAIL (
    ID_PenjualanDetail VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Penjualan VARCHAR(50) NOT NULL,
    ID_Produk VARCHAR(50) NOT NULL,
    Jumlah INT NOT NULL,
    SubTotalHargaJual DECIMAL(15,2) NOT NULL,
    HargaPerUnitJual DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (ID_Penjualan) REFERENCES PENJUALAN_HEADER(ID_Penjualan),
    FOREIGN KEY (ID_Produk) REFERENCES PRODUK(ID_Produk)
);

-- Tabel Log dan Audit

CREATE TABLE PERGERAKAN_STOK (
    ID_Pergerakan VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_Produk VARCHAR(50) NOT NULL,
    JenisPergerakan ENUM('PENJUALAN', 'PENERIMAAN', 'RESTOK AREA PENJUALAN', 'STOK OPNAMME') NOT NULL,
    Jumlah INT NOT NULL,
    TanggalWaktu DATETIME DEFAULT CURRENT_TIMESTAMP,
    ID_Pengguna VARCHAR(50) NOT NULL,
    Catatan TEXT,

    FOREIGN KEY (ID_Produk) REFERENCES PRODUK(ID_Produk),
    FOREIGN KEY (ID_Pengguna) REFERENCES PENGGUNA(ID_Pengguna)
);

CREATE TABLE PENYESUAIAN_STOK (
    ID_Penyesuaian VARCHAR(50) PRIMARY KEY NOT NULL,
    ID_InventoriLokasi VARCHAR(50) NOT NULL,
    JumlahSebelum INT NOT NULL,
    JumlahSesudah INT NOT NULL,
    AlasanPenyesuaian VARCHAR(100) NOT NULL,
    TanggalPenyesuaian DATETIME DEFAULT CURRENT_TIMESTAMP,
    ID_Pengguna VARCHAR(50) NOT NULL,

    FOREIGN KEY (ID_InventoriLokasi) REFERENCES INVENTORI_LOKASI(ID_InventoriLokasi),
    FOREIGN KEY (ID_Pengguna) REFERENCES PENGGUNA(ID_Pengguna)
);

-- Mematikan cek Foreign Key sementara untuk kemudahan INSERT
SET FOREIGN_KEY_CHECKS = 0;

-- Variabel untuk menyimpan ID yang akan digunakan kembali
SET @id_kat1 = 'KATG-001'; SET @id_kat2 = 'KATG-002'; SET @id_kat3 = 'KATG-003';
SET @id_pmsk1 = 'PMSK-001'; SET @id_pmsk2 = 'PMSK-002'; SET @id_pmsk3 = 'PMSK-003';
SET @id_png1 = 'PNG-001'; SET @id_png2 = 'PNG-002'; SET @id_png3 = 'PNG-003'; SET @id_png4 = 'PNG-004'; SET @id_png5 = 'PNG-005';
SET @id_lok1 = 'LOK-001'; SET @id_lok2 = 'LOK-002'; SET @id_lok3 = 'LOK-003';

-- 1. Data Dummy untuk Tabel: KATEGORI_PRODUK (3 data)
INSERT INTO KATEGORI_PRODUK (ID_Kategori, NamaKategori) VALUES
(@id_kat1, 'Elektronik'),
(@id_kat2, 'Pakaian'),
(@id_kat3, 'Perlengkapan Rumah');

-- 2. Data Dummy untuk Tabel: PEMASOK (3 data)
INSERT INTO PEMASOK (ID_Pemasok, NamaPemasok, AlamatPemasok, NoTeleponPemasok) VALUES
(@id_pmsk1, 'PT. Global Supplier Tech', 'Jl. Teknologi Raya No. 1, Jakarta', '021-11122233'),
(@id_pmsk2, 'CV. Mode Kreatif', 'Jl. Indah Jaya No. 5, Bandung', '022-44455566'),
(@id_pmsk3, 'UD. Kebutuhan Kita', 'Jl. Makmur Sentosa No. 10, Surabaya', '031-77788899');

-- 3. Data Dummy untuk Tabel: PENGGUNA (5 data)
INSERT INTO PENGGUNA (ID_Pengguna, NamaLengkap, Username, Jabatan_Karyawan) VALUES
(@id_png1, 'Budi Santoso', 'budis', 'KASIR'),
(@id_png2, 'Siti Aminah', 'sitia', 'STAF OPERASIONAL'),
(@id_png3, 'Agus Wijaya', 'agusw', 'ADMIN'),
(@id_png4, 'Dewi Lestari', 'dewil', 'MANAGER'),
(@id_png5, 'Candra Kirana', 'candrak', 'KASIR');

-- 4. Data Dummy untuk Tabel: LOKASI_PENYIMPANAN (3 data)
INSERT INTO LOKASI_PENYIMPANAN (ID_Lokasi, TipeLokasi) VALUES
(@id_lok1, 'Gudang Utama'),
(@id_lok2, 'Area Penjualan'),
(@id_lok3, 'Gudang Cadangan');

-- 5. Data Dummy untuk Tabel: PRODUK (10 data)
SET @id_prod1 = 'PROD-001'; SET @id_prod2 = 'PROD-002'; SET @id_prod3 = 'PROD-003';
SET @id_prod4 = 'PROD-004'; SET @id_prod5 = 'PROD-005'; SET @id_prod6 = 'PROD-006';
SET @id_prod7 = 'PROD-007'; SET @id_prod8 = 'PROD-008'; SET @id_prod9 = 'PROD-009';
SET @id_prod10 = 'PROD-010';

INSERT INTO PRODUK (ID_Produk, NamaProduk, Merek, ID_Kategori, HargaJual, StokSaatIni) VALUES
(@id_prod1, 'Laptop Gaming X1', 'TechPro', @id_kat1, 15000000.00, 0), -- Stok 0 akan diupdate oleh inventori
(@id_prod2, 'Smartphone Ultra Z', 'SmartFone', @id_kat1, 8500000.00, 0),
(@id_prod3, 'Smartwatch Elegance', 'WatchIt', @id_kat1, 1200000.00, 0),
(@id_prod4, 'Kemeja Batik Pria', 'BatikArt', @id_kat2, 250000.00, 0),
(@id_prod5, 'Gaun Pesta Wanita', 'Elegance', @id_kat2, 600000.00, 0),
(@id_prod6, 'Celana Jeans Slim Fit', 'DenimPro', @id_kat2, 300000.00, 0),
(@id_prod7, 'Vacuum Cleaner Robot', 'CleanBot', @id_kat3, 3500000.00, 0),
(@id_prod8, 'Panci Set Anti Lengket', 'CookMaster', @id_kat3, 900000.00, 0),
(@id_prod9, 'Lampu Tidur LED', 'BrightHome', @id_kat3, 150000.00, 0),
(@id_prod10, 'Speaker Bluetooth Mini', 'SoundBliss', @id_kat1, 400000.00, 0);


-- 6. Data Dummy untuk Tabel: INVENTORI_LOKASI (15 data - beberapa produk di beberapa lokasi)
SET @id_inv1 = 'INV-001'; SET @id_inv2 = 'INV-002'; SET @id_inv3 = 'INV-003'; SET @id_inv4 = 'INV-004'; SET @id_inv5 = 'INV-005';
SET @id_inv6 = 'INV-006'; SET @id_inv7 = 'INV-007'; SET @id_inv8 = 'INV-008'; SET @id_inv9 = 'INV-009'; SET @id_inv10 = 'INV-010';
SET @id_inv11 = 'INV-011'; SET @id_inv12 = 'INV-012'; SET @id_inv13 = 'INV-013'; SET @id_inv14 = 'INV-014'; SET @id_inv15 = 'INV-015';

INSERT INTO INVENTORI_LOKASI (ID_InventoriLokasi, ID_Lokasi, ID_Produk, StokDiLokasi) VALUES
(@id_inv1, @id_lok1, @id_prod1, 5),    -- Laptop di Gudang Utama
(@id_inv2, @id_lok2, @id_prod1, 2),    -- Laptop di Area Penjualan
(@id_inv3, @id_lok1, @id_prod2, 10),   -- Smartphone di Gudang Utama
(@id_inv4, @id_lok2, @id_prod2, 5),    -- Smartphone di Area Penjualan
(@id_inv5, @id_lok1, @id_prod3, 8),    -- Smartwatch di Gudang Utama
(@id_inv6, @id_lok2, @id_prod3, 3),    -- Smartwatch di Area Penjualan
(@id_inv7, @id_lok1, @id_prod4, 20),   -- Kemeja di Gudang Utama
(@id_inv8, @id_lok2, @id_prod4, 10),   -- Kemeja di Area Penjualan
(@id_inv9, @id_lok1, @id_prod5, 7),    -- Gaun di Gudang Utama
(@id_inv10, @id_lok2, @id_prod6, 15),  -- Celana di Area Penjualan
(@id_inv11, @id_lok1, @id_prod7, 3),   -- Vacuum di Gudang Utama
(@id_inv12, @id_lok3, @id_prod8, 12),  -- Panci di Gudang Cadangan
(@id_inv13, @id_lok1, @id_prod9, 25),  -- Lampu di Gudang Utama
(@id_inv14, @id_lok2, @id_prod10, 10), -- Speaker di Area Penjualan
(@id_inv15, @id_lok3, @id_prod10, 5);  -- Speaker di Gudang Cadangan

-- Update total StokSaatIni di tabel PRODUK berdasarkan INVENTORI_LOKASI
UPDATE PRODUK p
SET p.StokSaatIni = (SELECT SUM(il.StokDiLokasi) FROM INVENTORI_LOKASI il WHERE il.ID_Produk = p.ID_Produk GROUP BY il.ID_Produk);

-- 7. Data Dummy untuk Tabel: PO_HEADER (3 data)
SET @id_poh1 = 'POH-001'; SET @id_poh2 = 'POH-002'; SET @id_poh3 = 'POH-003';
INSERT INTO PO_HEADER (ID_Pemesanan, ID_Pemasok, ID_Pengguna, TanggalPemesanan, TanggalEstimasiSampai, StatusPemesanan, HargaTotal, Catatan) VALUES
(@id_poh1, @id_pmsk1, @id_png2, '2024-05-10 10:00:00', '2024-05-20 00:00:00', 'DISETUJUI', 30000000.00, 'Pemesanan laptop dan smartphone.'),
(@id_poh2, @id_pmsk2, @id_png2, '2024-05-12 11:30:00', '2024-05-22 00:00:00', 'DIBUAT', 1500000.00, 'Pemesanan pakaian musiman.'),
(@id_poh3, @id_pmsk3, @id_png2, '2024-05-15 09:00:00', '2024-05-25 00:00:00', 'SELESAI PARSIAL', 5000000.00, 'Pemesanan alat rumah tangga.');

-- 8. Data Dummy untuk Tabel: PO_DETAIL (6 data)
SET @id_pod1 = 'POD-001'; SET @id_pod2 = 'POD-002'; SET @id_pod3 = 'POD-003';
SET @id_pod4 = 'POD-004'; SET @id_pod5 = 'POD-005'; SET @id_pod6 = 'POD-006';
INSERT INTO PO_DETAIL (ID_PemesananDetail, ID_Pemesanan, ID_Produk, JumlahDipesan, JumlahDiterima, HargaSatuan, HargaSubTotal) VALUES
(@id_pod1, @id_poh1, @id_prod1, 2, 0, 14500000.00, 29000000.00), -- Laptop Gaming X1
(@id_pod2, @id_poh1, @id_prod3, 10, 0, 100000.00, 1000000.00), -- Smartwatch
(@id_pod3, @id_poh2, @id_prod4, 5, 0, 200000.00, 1000000.00),  -- Kemeja Batik
(@id_pod4, @id_poh2, @id_prod6, 10, 0, 50000.00, 500000.00),   -- Celana Jeans
(@id_pod5, @id_poh3, @id_prod7, 1, 1, 3500000.00, 3500000.00), -- Vacuum Cleaner (sudah diterima)
(@id_pod6, @id_poh3, @id_prod8, 2, 0, 750000.00, 1500000.00);  -- Panci Set

-- 9. Data Dummy untuk Tabel: PENERIMAAN_HEADER (2 data)
SET @id_prh1 = 'PRH-001'; SET @id_prh2 = 'PRH-002';
INSERT INTO PENERIMAAN_HEADER (ID_Penerimaan, ID_Pemesanan, ID_Pengguna, TanggalTerima, Catatan) VALUES
(@id_prh1, @id_poh3, @id_png2, '2024-05-20 14:00:00', 'Penerimaan sebagian PO-003 (Vacuum Cleaner).'),
(@id_prh2, @id_poh1, @id_png2, '2024-05-21 16:00:00', 'Penerimaan penuh PO-001 (Laptop dan Smartwatch).');

-- 10. Data Dummy untuk Tabel: PENERIMAAN_DETAIL (4 data)
SET @id_prdet1 = 'PRDET-001'; SET @id_prdet2 = 'PRDET-002'; SET @id_prdet3 = 'PRDET-003'; SET @id_prdet4 = 'PRDET-004';
INSERT INTO PENERIMAAN_DETAIL (ID_PenerimaanDetail, ID_Penerimaan, ID_Produk, ID_Lokasi, JumlahDiterima) VALUES
(@id_prdet1, @id_prh1, @id_prod7, @id_lok1, 1),    -- Vacuum Cleaner diterima di Gudang Utama
(@id_prdet2, @id_prh2, @id_prod1, @id_lok1, 2),    -- Laptop diterima di Gudang Utama
(@id_prdet3, @id_prh2, @id_prod3, @id_lok1, 10),   -- Smartwatch diterima di Gudang Utama
(@id_prdet4, @id_prh2, @id_prod3, @id_lok2, 5);    -- Smartwatch diterima di Area Penjualan (contoh stok ke 2 lokasi)

-- 11. Data Dummy untuk Tabel: PENJUALAN_HEADER (3 data)
SET @id_pjh1 = 'PJH-001'; SET @id_pjh2 = 'PJH-002'; SET @id_pjh3 = 'PJH-003';
INSERT INTO PENJUALAN_HEADER (ID_Penjualan, ID_Pengguna, TanggalPenjualan, TotalHargaJual, TotalJumlahProduk) VALUES
(@id_pjh1, @id_png1, '2024-06-01 09:30:00', 16000000.00, 2), -- Laptop + Kemeja
(@id_pjh2, @id_png5, '2024-06-02 14:00:00', 8500000.00, 1), -- Smartphone
(@id_pjh3, @id_png1, '2024-06-03 11:00:00', 1700000.00, 5); -- Smartwatch + Lampu Tidur

-- 12. Data Dummy untuk Tabel: PENJUALAN_DETAIL (6 data)
SET @id_pjdet1 = 'PJDET-001'; SET @id_pjdet2 = 'PJDET-002'; SET @id_pjdet3 = 'PJDET-003';
SET @id_pjdet4 = 'PJDET-004'; SET @id_pjdet5 = 'PJDET-005'; SET @id_pjdet6 = 'PJDET-006';
INSERT INTO PENJUALAN_DETAIL (ID_PenjualanDetail, ID_Penjualan, ID_Produk, Jumlah, SubTotalHargaJual, HargaPerUnitJual) VALUES
(@id_pjdet1, @id_pjh1, @id_prod1, 1, 15000000.00, 15000000.00), -- Laptop
(@id_pjdet2, @id_pjh1, @id_prod4, 1, 250000.00, 250000.00),    -- Kemeja Batik
(@id_pjdet3, @id_pjh2, @id_prod2, 1, 8500000.00, 8500000.00),    -- Smartphone
(@id_pjdet4, @id_pjh3, @id_prod3, 3, 3600000.00, 1200000.00),    -- Smartwatch
(@id_pjdet5, @id_pjh3, @id_prod9, 2, 300000.00, 150000.00),     -- Lampu Tidur
(@id_pjdet6, @id_pjh3, @id_prod10, 1, 400000.00, 400000.00);    -- Speaker Bluetooth

-- 13. Data Dummy untuk Tabel: PERGERAKAN_STOK (5 data - contoh pergerakan)
SET @id_ps1 = 'PS-001'; SET @id_ps2 = 'PS-002'; SET @id_ps3 = 'PS-003'; SET @id_ps4 = 'PS-004'; SET @id_ps5 = 'PS-005';
INSERT INTO PERGERAKAN_STOK (ID_Pergerakan, ID_Produk, JenisPergerakan, Jumlah, TanggalWaktu, ID_Pengguna, Catatan) VALUES
(@id_ps1, @id_prod1, 'PENERIMAAN', 2, '2024-05-21 16:00:00', @id_png2, 'Penerimaan dari PO-001'),
(@id_ps2, @id_prod1, 'PENJUALAN', -1, '2024-06-01 09:30:00', @id_png1, 'Penjualan ke pelanggan'),
(@id_ps3, @id_prod7, 'PENERIMAAN', 1, '2024-05-20 14:00:00', @id_png2, 'Penerimaan dari PO-003'),
(@id_ps4, @id_prod4, 'PENJUALAN', -1, '2024-06-01 09:30:00', @id_png1, 'Penjualan ke pelanggan'),
(@id_ps5, @id_prod3, 'RESTOK AREA PENJUALAN', -5, '2024-06-04 08:00:00', @id_png2, 'Transfer dari gudang utama ke area penjualan');



-- Mengaktifkan kembali cek Foreign Key
SET FOREIGN_KEY_CHECKS = 1;

