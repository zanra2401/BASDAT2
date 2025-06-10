USE invictus;

SELECT * FROM INVENTORI_LOKASI WHERE ID_PRODUK = "PROD-007";

-- SP ID GENERATOR

DELIMITER $$

CREATE PROCEDURE GeneratePYID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Penyesuaian,4) AS UNSIGNED)),0)
    INTO v_angka
    FROM penyesuaian_stok;
    
    SET o_hasil = CONCAT("PY-", LPAD(v_angka + 1, 3, '0'));
    
END $$


DROP PROCEDURE IF EXISTS GenerateCatID $$
CREATE PROCEDURE GenerateCatID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Kategori,6) AS UNSIGNED)),0)
    INTO v_angka
    FROM KATEGORI_PRODUK;
    
    SET o_hasil = CONCAT("KATG-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateSupID $$
CREATE PROCEDURE GenerateSupID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Pemasok,6) AS UNSIGNED)),0)
    INTO v_angka
    FROM PEMASOK;
    
    SET o_hasil = CONCAT("PMSK-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateUsrID $$
CREATE PROCEDURE GenerateUsrID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Pengguna,5) AS UNSIGNED)),0)
    INTO v_angka
    FROM PENGGUNA;
    
    SET o_hasil = CONCAT("PNG-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateLocID $$
CREATE PROCEDURE GenerateLocID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    

    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Lokasi,5) AS UNSIGNED)),0)
    INTO v_angka
    FROM LOKASI_PENYIMPANAN;
    
    SET o_hasil = CONCAT("LOK-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateProdID $$
CREATE PROCEDURE GenerateProdID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Produk,6) AS UNSIGNED)),0)
    INTO v_angka
    FROM PRODUK;
    
    SET o_hasil = CONCAT("PROD-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateInvLocID $$
CREATE PROCEDURE GenerateInvLocID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_InventoriLokasi,5) AS UNSIGNED)),0)
    INTO v_angka
    FROM INVENTORI_LOKASI;
    
    SET o_hasil = CONCAT("INV-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GeneratePOHID $$
CREATE PROCEDURE GeneratePOHID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Pemesanan,5) AS UNSIGNED)),0)
    INTO v_angka
    FROM PO_HEADER;
    
    SET o_hasil = CONCAT("POH-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GeneratePODetID $$
CREATE PROCEDURE GeneratePODetID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_PemesananDetail,7) AS UNSIGNED)),0)
    INTO v_angka
    FROM PO_DETAIL;
    
    SET o_hasil = CONCAT("PODET-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateRcvHID $$
CREATE PROCEDURE GenerateRcvHID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Penerimaan,5) AS UNSIGNED)),0)
    INTO v_angka
    FROM PENERIMAAN_HEADER;
    
    SET o_hasil = CONCAT("PRH-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateRcvDetID $$
CREATE PROCEDURE GenerateRcvDetID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_PenerimaanDetail,7) AS UNSIGNED)),0)
    INTO v_angka
    FROM PENERIMAAN_DETAIL;
    
    SET o_hasil = CONCAT("PRDET-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateSaleHID $$
CREATE PROCEDURE GenerateSaleHID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Penjualan,5) AS UNSIGNED)),0)
    INTO v_angka
    FROM PENJUALAN_HEADER;
    
    SET o_hasil = CONCAT("PJH-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateSaleDetID $$
CREATE PROCEDURE GenerateSaleDetID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_PenjualanDetail,7) AS UNSIGNED)),0)
    INTO v_angka
    FROM PENJUALAN_DETAIL;
    
    SET o_hasil = CONCAT("PJDET-", LPAD(v_angka + 1, 3, '0'));
END $$


DROP PROCEDURE IF EXISTS GenerateMovID $$
CREATE PROCEDURE GenerateMovID(
    OUT o_hasil VARCHAR(50)
)
BEGIN
    DECLARE v_angka INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(ID_Pergerakan,4) AS UNSIGNED)),0)
    INTO v_angka
    FROM PERGERAKAN_STOK;
    
    SET o_hasil = CONCAT("PS-", LPAD(v_angka + 1, 3, '0'));
END $$

DELIMITER ;

DELIMITER $$
	DROP TRIGGER IF EXISTS TRPenjualan_AFTER_INSERT $$
	CREATE TRIGGER TRPenjualan_AFTER_INSERT
	AFTER INSERT ON PENJUALAN_DETAIL
	FOR EACH ROW
	BEGIN
  		UPDATE inventori_lokasi IL
  		SET IL.StokDiLokasi = IL.StokDiLokasi - NEW.Jumlah
  		WHERE IL.ID_Produk = NEW.ID_Produk
  		AND IL.ID_Lokasi = (SELECT ID_Lokasi FROM lokasi_penyimpanan lp WHERE lp.TipeLokasi = 'Area Penjualan');
  		
  		UPDATE produk SET StokSaatIni = StokSaatIni - NEW.Jumlah
  		WHERE ID_Produk = NEW.ID_Produk;
  		
  		CALL GenerateMovID(@id_pergerakan_stok_trpen);
  		
  		INSERT pergerakan_stok VALUES(
			@id_pergerakan_stok_trpen,
			NEW.ID_Produk,
			'PENJUALAN',
			0 - NEW.Jumlah,
			NOW(),
			(SELECT ID_Pengguna FROM penjualan_header WHERE ID_Penjualan = NEW.ID_Penjualan),
			"Penjualan Biasa"
		);
	  	
	END $$
DELIMITER ;


DELIMITER $$
	DROP TRIGGER IF EXISTS TRPenerimaan_AFTER_INSERT $$
	CREATE TRIGGER TRPenerimaan_AFTER_INSERT
	AFTER INSERT ON PENERIMAAN_DETAIL 
	FOR EACH ROW
	BEGIN	 
		IF EXISTS(SELECT ID_Lokasi FROM inventori_lokasi IL WHERE IL.ID_Lokasi = NEW.ID_Lokasi AND IL.ID_Produk = NEW.ID_Produk) THEN
			UPDATE INVENTORI_LOKASI IL
		 	SET IL.StokDiLokasi = IL.StokDiLokasi + NEW.JumlahDiterima
	    	WHERE IL.ID_Produk = NEW.ID_Produk
	    	AND IL.ID_Lokasi = NEW.ID_Produk;
		ELSE
			CALL GenerateInvLocID(@id_invloc_trterima);
       	INSERT INTO INVENTORI_LOKASI (ID_InventoriLokasi, ID_Lokasi, ID_Produk, StokDiLokasi, TanggalUpdateStok)
       	VALUES (
         	@id_invloc_trterima,
         	NEW.ID_Lokasi,
         	NEW.ID_Produk,
         	NEW.JumlahDiterima,
         	NOW()
       	);
		END IF;
		
		UPDATE produk P
    	SET P.StokSaatIni = P.StokSaatIni + NEW.JumlahDiterima
    	WHERE P.ID_Produk = NEW.ID_Produk;
    	
    	CALL GenerateMovID(@id_pergerakan_stok_penerimaan);
    
    	INSERT pergerakan_stok VALUES(
	 		@id_pergerakan_stok_penerimaan,
	 		NEW.ID_Produk,
	 		'Penerimaan',
	 		NEW.JumlahDiterima,
	 		NOW(),
	 		(SELECT ID_Pengguna FROM Penerimaan_Header WHERE ID_Penerimaan = NEW.ID_Penerimaan),
	 		"Penerimaan Barang"
	 	);
		 	
	END $$
DELIMITER ;

-- Penjualan CONTOH

SELECT * FROM Produk WHERE ID_PRODUK = 'PROD-001';
INSERT INTO Penjualan_Header VALUES('PJH-004', 'PNG-001', NOW(), 15000000, 1);
INSERT INTO Penjualan_Detail VALUES('PJDET-007', 'PJH-004', 'PROD-001', 1, 15000000, 15000000);
SELECT * FROM Produk WHERE ID_PRODUK = 'PROD-001';
SELECT * FROM pergerakan_stok;

-- Penerimaan CONTOH

INSERT INTO PENERIMAAN_HEADER (ID_Penerimaan, ID_Pemesanan, ID_Pengguna, TanggalTerima, Catatan)
VALUES ('PRH-TEST01', NULL, 'PNG-002', NOW(), 'Penerimaan barang untuk pengujian trigger.');
INSERT INTO PENERIMAAN_DETAIL (ID_PenerimaanDetail, ID_Penerimaan, ID_Produk, ID_Lokasi, JumlahDiterima)
VALUES ('PRDET-TEST01', 'PRH-TEST01', 'PROD-001', 'LOK-001', 5);

SELECT * FROM inventori_lokasi WHERE ID_Produk = 'PROD-001';

-- Stok Opname

DELIMITER $$

	DROP PROCEDURE IF EXISTS SP_StockOpname $$
	
	CREATE PROCEDURE SP_StockOpname(
		IN i_InvLokasi VARCHAR(50),
		IN i_jumlah_penyesuaian INT,
		IN i_alasan TEXT,
		IN i_pengguna VARCHAR(50)
	) 
	BEGIN 
		DECLARE v_jumlah_sistem INT;
		DECLARE v_py_id VARCHAR(50);
		
		SELECT StokDiLokasi INTO v_jumlah_sistem 
		FROM inventori_lokasi
		WHERE ID_InventoriLokasi = i_InvLokasi;
		
		CALL GeneratePYID(v_py_id);
		
		INSERT INTO penyesuaian_stok VALUES(
			v_py_id,
			v_InvLokasi,
			v_jumlah_sistem,
			i_jumlah_peyesuaian,
			i_alasan,
			NOW(),
			i_pengguna
		);
		
		UPDATE penyesuaian_stok SET StokDiLokasi = i_jumlah_penyesuaian WHERE ID_InvLokasi = i_InventoriLokasi;		
	END $$
	
DELIMITER ;


-- VIEW UNTUK DAFTAR PEMESANAN
DROP VIEW IF EXISTS v_daftarpemesanan;
CREATE VIEW V_DaftarPemesanan AS
SELECT
	ph.ID_Pemesanan,
	pd.ID_PemesananDetail,
	p.ID_Produk,
	pmk.ID_Pemasok,
	png.ID_Pengguna AS ID_Pemesan,
	p.NamaProduk,
	pd.JumlahDipesan,
	pd.JumlahDiterima,
	pd.HargaSatuan,
	pd.HargaSubTotal,
	ph.TanggalPemesanan,
	ph.StatusPemesanan,
	ph.Catatan,
	png.NamaLengkap AS NamaPemesan
FROM
po_header ph,
po_detail pd,
produk p,
pengguna png,
pemasok pmk
WHERE 
p.ID_Produk = pd.ID_Produk
AND
pd.ID_Pemesanan = ph.ID_Pemesanan
AND
ph.ID_Pengguna = png.ID_Pengguna
AND
pmk.ID_Pemasok = ph.ID_Pemasok;


SELECT * FROM V_DaftarPemesanan;

-- VIEW Riwayat Penjualan
DROP VIEW IF EXISTS V_DaftarPenjualan;
CREATE VIEW V_DaftarPenjualan AS
SELECT 
	ph.ID_Penjualan,
	pd.ID_PenjualanDetail,
	p.ID_Produk,
	png.ID_Pengguna,
	
	p.NamaProduk,
	png.NamaLengkap,
	pd.HargaPerUnitJual,
	pd.SubTotalHargaJual,
	pd.Jumlah,
	p.Merek,
	ph.TanggalPenjualan
FROM 
penjualan_header ph,
penjualan_detail pd,
pengguna png,
produk p
WHERE 
p.ID_Produk = pd.ID_Produk
AND
ph.ID_Pengguna	 = png.ID_Pengguna
AND
pd.ID_Penjualan = ph.ID_Penjualan;

DELIMITER $$

	DROP PROCEDURE IF EXISTS SP_HPP_FIFO;
	
	CREATE PROCEDURE SP_HPP_FIFO(
		IN tanggal_mulai DATETIME,
		IN tanggal_akhir DATETIME
	)
	BEGIN
		DECLARE v_hpp_terhitung DECIMAL(10, 2);
		DECLARE v_pendapatan DECIMAL(15, 2);
		DECLARE v_keuntunganKotor DECIMAL(15, 2);
		
		
		DROP TEMPORARY TABLE IF EXISTS temp_LaporanKeuntunganFIFO;
    	CREATE TEMPORARY TABLE temp_LaporanKeuntunganFIFO (
        ID_Penjualan VARCHAR(50),
        TanggalPenjualan DATETIME,
        ID_Produk VARCHAR(50),
        NamaProduk VARCHAR(100),
        JumlahTerjual INT,
        HargaPerUnitJual DECIMAL(10,2),
        HPP_Terhitung DECIMAL(10,2),
        Rata_HPP DECIMAL(10, 2),
        pendapatan DECIMAL(15, 2),
        KeuntunganKotor DECIMAL(15,2),
        DetailAlokasi TEXT -- Untuk mendemonstrasikan dari batch mana stok diambil
    	);
    	
    	
    	
	END $$
	
DELIMITER ;