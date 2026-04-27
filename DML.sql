INSERT INTO Penyewa (id_penyewa, nama_penyewa, nomor_identitas, kontak) VALUES
(1,'Andi Saputra','317001','0811111111'),
(2,'Siti Rahma','317002','0822222222'),
(3,'Budi Santoso','317003','0833333333'),
(4,'Dewi Lestari','317004','0844444444'),
(5,'Rizky Pratama','317005','0855555555'),
(6,'Nina Aulia','317006','0866666666'),
(7,'Fajar Hidayat','317007','0877777777'),
(8,'Putri Ayu','317008','0888888888'),
(9,'Agus Salim','317009','0899999999'),
(10,'Maya Sari','317010','0800000000');

INSERT INTO Properti (id_properti, id_pengelola, nama_properti, alamat, tipe_properti) VALUES
(1,1,'Kos Melati','Jl. Melati 1','Kos'),
(2,1,'Kos Mawar','Jl. Mawar 2','Kos'),
(3,1,'Apartemen Sakura','Jl. Sakura 3','Apartemen'),
(4,1,'Apartemen Anggrek','Jl. Anggrek 4','Apartemen'),
(5,1,'Kos Dahlia','Jl. Dahlia 5','Kos'),
(6,1,'Kos Kenanga','Jl. Kenanga 6','Kos'),
(7,1,'Apartemen Tulip','Jl. Tulip 7','Apartemen'),
(8,1,'Kos Flamboyan','Jl. Flamboyan 8','Kos'),
(9,1,'Apartemen Orchid','Jl. Orchid 9','Apartemen'),
(10,1,'Kos Bougenville','Jl. Bougenville 10','Kos');

INSERT INTO Unit (id_unit, id_properti, nomor_unit, lantai, tipe_unit, luas_m2, harga_per_bulan, status_unit) VALUES
(1,1,'A1',1,'Single',20,1000000,'Tersedia'),
(2,2,'A2',1,'Double',30,1500000,'Terisi'),
(3,3,'B1',2,'Studio',25,2000000,'Tersedia'),
(4,4,'B2',2,'1BR',35,2500000,'Terisi'),
(5,5,'C1',1,'Single',20,1100000,'Tersedia'),
(6,6,'C2',1,'Double',30,1600000,'Maintenance'),
(7,7,'D1',3,'Studio',28,2100000,'Tersedia'),
(8,8,'D2',2,'Single',22,1200000,'Terisi'),
(9,9,'E1',4,'2BR',40,3000000,'Tersedia'),
(10,10,'E2',1,'Single',18,900000,'Tersedia');

INSERT INTO Booking (id_booking, id_penyewa, id_unit, tanggal_booking, jumlah_deposit, status_booking) VALUES
(1,1,2,'2026-04-01',500000,'Diterima'),
(2,2,1,'2026-04-02',300000,'Pending'),
(3,3,3,'2026-04-03',400000,'Diterima'),
(4,4,4,'2026-04-04',600000,'Ditolak'),
(5,5,5,'2026-04-05',350000,'Diterima'),
(6,6,6,'2026-04-06',450000,'Pending'),
(7,7,7,'2026-04-07',500000,'Diterima'),
(8,8,8,'2026-04-08',300000,'Diterima'),
(9,9,9,'2026-04-09',700000,'Pending'),
(10,10,10,'2026-04-10',250000,'Diterima');

INSERT INTO Kontrak_Sewa (id_kontrak, id_booking, tanggal_mulai, tanggal_berakhir, harga_sewa, status_kontrak) VALUES
(1,1,'2026-04-10','2026-10-10',6000000,'Aktif'),
(2,3,'2026-04-11','2026-10-11',7000000,'Aktif'),
(3,5,'2026-04-12','2026-10-12',6500000,'Aktif'),
(4,7,'2026-04-13','2026-10-13',7200000,'Diperpanjang'),
(5,8,'2026-04-14','2026-10-14',6800000,'Aktif'),
(6,10,'2026-04-15','2026-10-15',5000000,'Aktif'),
(7,2,'2026-04-16','2026-10-16',5500000,'Berakhir'),
(8,4,'2026-04-17','2026-10-17',7500000,'Aktif'),
(9,6,'2026-04-18','2026-10-18',6200000,'Aktif'),
(10,9,'2026-04-19','2026-10-19',8000000,'Aktif');

INSERT INTO Pembayaran (id_pembayaran, id_kontrak, tanggal_pembayaran, periode_bulan, jumlah_bayar, metode, status_pembayaran) VALUES
(1,1,'2026-04-10','April',1000000,'Transfer','Lunas'),
(2,2,'2026-04-11','April',1200000,'Tunai','Lunas'),
(3,3,'2026-04-12','April',1100000,'Transfer','Lunas'),
(4,4,'2026-04-13','April',1300000,'Transfer','Menunggak'),
(5,5,'2026-04-14','April',1150000,'Tunai','Lunas'),
(6,6,'2026-04-15','April',900000,'Transfer','Lunas'),
(7,7,'2026-04-16','April',950000,'Tunai','Menunggak'),
(8,8,'2026-04-17','April',1400000,'Transfer','Lunas'),
(9,9,'2026-04-18','April',1250000,'Transfer','Lunas'),
(10,10,'2026-04-19','April',1500000,'Tunai','Lunas');

INSERT INTO Maintenance_Request (id_request, id_kontrak, id_teknisi, tanggal_request, deskripsi_kerusakan, prioritas, status_request, catatan_penyelesaian) VALUES
(1,1,1,'2026-04-20','AC rusak','Tinggi','Selesai','Sudah diperbaiki'),
(2,2,2,'2026-04-21','Lampu mati','Sedang','Pengerjaan',NULL),
(3,3,1,'2026-04-22','Air bocor','Tinggi','Selesai','Pipa diganti'),
(4,4,2,'2026-04-23','Wifi lambat','Rendah','Diajukan',NULL),
(5,5,1,'2026-04-24','Kipas rusak','Sedang','Selesai','Kipas diganti'),
(6,6,2,'2026-04-25','Pintu macet','Rendah','Pengerjaan',NULL),
(7,7,1,'2026-04-26','AC bocor','Tinggi','Selesai','Diperbaiki'),
(8,8,2,'2026-04-27','Stop kontak rusak','Sedang','Diajukan',NULL),
(9,9,1,'2026-04-28','Keran bocor','Rendah','Selesai','Diganti'),
(10,10,2,'2026-04-29','Lampu redup','Rendah','Pengerjaan',NULL);