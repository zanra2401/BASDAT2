tIni = StokSaatIni - NEW.Jumlah
	    WHERE ID_Produk = NEW.ID_Produk;
	    
	    CALL GenerateMovID(@id_pergerakan_stok);
	    
	    INSERT pergerakan_stok VALUES(
		 	@id_pergerakan_stok,
		 	NEW.ID_Produk,
		 	'PENJUALAN',
		 	0 - NEW.Jumlah,
		 	NOW(),
		 	(SELECT ID_Pengguna FROM penjualan_header WHERE ID_Penjualan = NEW.ID_Penjualan),
		 	"Penjualan Biasa"
		 );