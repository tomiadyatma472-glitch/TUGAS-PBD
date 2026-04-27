CREATE DATABASE IF NOT EXISTS propertyhub_db;
USE propertyhub_db;


CREATE TABLE Pengelola (
    ID_Pengelola INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Pengelola VARCHAR(100) NOT NULL,
    Nomor_Kontak VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Fasilitas (
    ID_Fasilitas INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Fasilitas VARCHAR(100) NOT NULL,
    Kategori ENUM('Unit', 'Bersama') NOT NULL
);

CREATE TABLE Penyewa (
    ID_Penyewa INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Penyewa VARCHAR(100) NOT NULL,
    Nomor_Identitas VARCHAR(50) UNIQUE NOT NULL, 
    Kontak VARCHAR(20) NOT NULL
);

CREATE TABLE Teknisi (
    ID_Teknisi INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Teknisi VARCHAR(100) NOT NULL,
    Keahlian VARCHAR(100) NOT NULL
);

CREATE TABLE Properti (
    ID_Properti INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pengelola INT NOT NULL,
    Nama_Properti VARCHAR(100) NOT NULL,
    Alamat TEXT NOT NULL,
    Tipe_Properti ENUM('Kos', 'Apartemen') NOT NULL,
    FOREIGN KEY (ID_Pengelola) REFERENCES Pengelola(ID_Pengelola) ON DELETE RESTRICT
);

CREATE TABLE Unit (
    ID_Unit INT AUTO_INCREMENT PRIMARY KEY,
    ID_Properti INT NOT NULL,
    Nomor_Unit VARCHAR(20) NOT NULL,
    Lantai VARCHAR(10) NOT NULL,
    Tipe_Unit ENUM('Single', 'Double', 'Studio', '1BR', '2BR') NOT NULL,
    Luas_m2 DECIMAL(10, 2) NOT NULL,
    Harga_Per_Bulan DECIMAL(15, 2) NOT NULL,
    Status_Unit ENUM('Tersedia', 'Terisi', 'Maintenance') NOT NULL DEFAULT 'Tersedia',
    FOREIGN KEY (ID_Properti) REFERENCES Properti(ID_Properti) ON DELETE CASCADE
);

CREATE TABLE Fasilitas_Properti (
    ID_Properti INT NOT NULL,
    ID_Fasilitas INT NOT NULL,
    PRIMARY KEY (ID_Properti, ID_Fasilitas),
    FOREIGN KEY (ID_Properti) REFERENCES Properti(ID_Properti) ON DELETE CASCADE,
    FOREIGN KEY (ID_Fasilitas) REFERENCES Fasilitas(ID_Fasilitas) ON DELETE CASCADE
);

CREATE TABLE Fasilitas_Unit (
    ID_Unit INT NOT NULL,
    ID_Fasilitas INT NOT NULL,
    PRIMARY KEY (ID_Unit, ID_Fasilitas),
    FOREIGN KEY (ID_Unit) REFERENCES Unit(ID_Unit) ON DELETE CASCADE,
    FOREIGN KEY (ID_Fasilitas) REFERENCES Fasilitas(ID_Fasilitas) ON DELETE CASCADE
);

CREATE TABLE Booking (
    ID_Booking INT AUTO_INCREMENT PRIMARY KEY,
    ID_Penyewa INT NOT NULL,
    ID_Unit INT NOT NULL,
    Tanggal_Booking DATE NOT NULL,
    Jumlah_Deposit DECIMAL(10,2) NOT NULL CHECK (Jumlah_Deposit > 0), 
    Status_Booking ENUM('Pending', 'Diterima', 'Ditolak') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (ID_Penyewa) REFERENCES Penyewa(ID_Penyewa) ON DELETE CASCADE,
    FOREIGN KEY (ID_Unit) REFERENCES Unit(ID_Unit) ON DELETE RESTRICT
);

CREATE TABLE Kontrak_Sewa (
    ID_Kontrak INT AUTO_INCREMENT PRIMARY KEY,
    ID_Booking INT NOT NULL UNIQUE, 
    Tanggal_Mulai DATE NOT NULL,
    Tanggal_Berakhir DATE NOT NULL,
    Harga_Sewa DECIMAL(15,2) NOT NULL,
    Status_Kontrak ENUM('Aktif', 'Berakhir', 'Diperpanjang') NOT NULL DEFAULT 'Aktif',
    FOREIGN KEY (ID_Booking) REFERENCES Booking(ID_Booking) ON DELETE RESTRICT,
    CONSTRAINT chk_tanggal_kontrak CHECK (Tanggal_Mulai <= Tanggal_Berakhir)
);

CREATE TABLE Pembayaran (
    ID_Pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    ID_Kontrak INT NOT NULL,
    Tanggal_Pembayaran DATE NOT NULL,
    Periode_Bulan VARCHAR(7) NOT NULL, 
    Jumlah_Bayar DECIMAL(15, 2) NOT NULL CHECK (Jumlah_Bayar > 0),
    Metode ENUM('Transfer', 'Tunai') NOT NULL,
    Status_Pembayaran ENUM('Lunas', 'Menunggak') NOT NULL DEFAULT 'Menunggak',
    FOREIGN KEY (ID_Kontrak) REFERENCES Kontrak_Sewa(ID_Kontrak) ON DELETE CASCADE
);

CREATE TABLE Maintenance_Request (
    ID_Request INT AUTO_INCREMENT PRIMARY KEY,
    ID_Kontrak INT NOT NULL,
    ID_Teknisi INT,
    Tanggal_Request DATE NOT NULL,
    Deskripsi_Kerusakan TEXT NOT NULL,
    Prioritas ENUM('Rendah', 'Sedang', 'Tinggi') NOT NULL DEFAULT 'Sedang',
    Status_Request ENUM('Diajukan', 'Pengerjaan', 'Selesai') NOT NULL DEFAULT 'Diajukan',
    Catatan_Penyelesaian TEXT,
    FOREIGN KEY (ID_Kontrak) REFERENCES Kontrak_Sewa(ID_Kontrak) ON DELETE CASCADE,
    FOREIGN KEY (ID_Teknisi) REFERENCES Teknisi(ID_Teknisi) ON DELETE SET NULL
);

INSERT INTO Pengelola (ID_Pengelola, Nama_Pengelola, Nomor_Kontak) VALUES
(1,'PT Properti Jaya','0811111111'),
(2,'CV Hunian Sejahtera','0822222222'),
(3,'PT Kos Indonesia','0833333333'),
(4,'PT Apartemen Maju','0844444444'),
(5,'CV Properti Mandiri','0855555555'),
(6,'PT Hunian Nyaman','0866666666'),
(7,'PT Rumah Kita','0877777777'),
(8,'CV Sewa Properti','0888888888'),
(9,'PT Urban Living','0899999999'),
(10,'PT Properti Nusantara','0800000000');

INSERT INTO Fasilitas VALUES
(1,'AC','Unit'),
(2,'WiFi','Bersama'),
(3,'TV','Unit'),
(4,'Kulkas','Unit'),
(5,'Parkir','Bersama'),
(6,'Gym','Bersama'),
(7,'Kolam Renang','Bersama'),
(8,'Meja','Unit'),
(9,'Kasur','Unit'),
(10,'Dapur','Bersama');

INSERT INTO Penyewa VALUES
(1,'Andi','317001','0811111111'),
(2,'Siti','317002','0822222222'),
(3,'Budi','317003','0833333333'),
(4,'Dewi','317004','0844444444'),
(5,'Rizky','317005','0855555555'),
(6,'Nina','317006','0866666666'),
(7,'Fajar','317007','0877777777'),
(8,'Putri','317008','0888888888'),
(9,'Agus','317009','0899999999'),
(10,'Maya','317010','0800000000');

INSERT INTO Teknisi VALUES
(1,'Budi Teknik','AC'),
(2,'Andi Service','Listrik'),
(3,'Joko Repair','Air'),
(4,'Slamet Fix','Bangunan'),
(5,'Tono Tech','Elektronik'),
(6,'Rudi Service','AC'),
(7,'Agus Repair','Air'),
(8,'Dedi Teknik','Listrik'),
(9,'Feri Fix','Bangunan'),
(10,'Yanto Tech','Elektronik');

INSERT INTO Properti VALUES
(1,1,'Kos Melati','Jl Melati','Kos'),
(2,2,'Kos Mawar','Jl Mawar','Kos'),
(3,3,'Apt Sakura','Jl Sakura','Apartemen'),
(4,4,'Apt Anggrek','Jl Anggrek','Apartemen'),
(5,5,'Kos Dahlia','Jl Dahlia','Kos'),
(6,6,'Kos Kenanga','Jl Kenanga','Kos'),
(7,7,'Apt Tulip','Jl Tulip','Apartemen'),
(8,8,'Kos Flamboyan','Jl Flamboyan','Kos'),
(9,9,'Apt Orchid','Jl Orchid','Apartemen'),
(10,10,'Kos Bougenville','Jl Bougenville','Kos');

INSERT INTO Unit VALUES
(1,1,'A1','1','Single',20,1000000,'Tersedia'),
(2,2,'A2','1','Double',30,1500000,'Terisi'),
(3,3,'B1','2','Studio',25,2000000,'Tersedia'),
(4,4,'B2','2','1BR',35,2500000,'Terisi'),
(5,5,'C1','1','Single',20,1100000,'Tersedia'),
(6,6,'C2','1','Double',30,1600000,'Maintenance'),
(7,7,'D1','3','Studio',28,2100000,'Tersedia'),
(8,8,'D2','2','Single',22,1200000,'Terisi'),
(9,9,'E1','4','2BR',40,3000000,'Tersedia'),
(10,10,'E2','1','Single',18,900000,'Tersedia');

INSERT INTO Fasilitas_Properti VALUES
(1,2),(2,2),(3,6),(4,7),(5,5),
(6,2),(7,7),(8,5),(9,6),(10,2);

INSERT INTO Fasilitas_Unit VALUES
(1,1),(2,3),(3,4),(4,1),(5,8),
(6,9),(7,1),(8,3),(9,4),(10,9);

INSERT INTO Booking VALUES
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

INSERT INTO Kontrak_Sewa VALUES
(1,1,'2026-04-10','2026-10-10',6000000,'Aktif'),
(2,2,'2026-04-11','2026-10-11',5500000,'Berakhir'),
(3,3,'2026-04-12','2026-10-12',7000000,'Aktif'),
(4,4,'2026-04-13','2026-10-13',7500000,'Aktif'),
(5,5,'2026-04-14','2026-10-14',6500000,'Aktif'),
(6,6,'2026-04-15','2026-10-15',6200000,'Aktif'),
(7,7,'2026-04-16','2026-10-16',7200000,'Diperpanjang'),
(8,8,'2026-04-17','2026-10-17',6800000,'Aktif'),
(9,9,'2026-04-18','2026-10-18',8000000,'Aktif'),
(10,10,'2026-04-19','2026-10-19',5000000,'Aktif');

INSERT INTO Pembayaran VALUES
(1,1,'2026-04-10','2026-04',1000000,'Transfer','Lunas'),
(2,2,'2026-04-11','2026-04',900000,'Tunai','Lunas'),
(3,3,'2026-04-12','2026-04',1200000,'Transfer','Lunas'),
(4,4,'2026-04-13','2026-04',1300000,'Transfer','Menunggak'),
(5,5,'2026-04-14','2026-04',1100000,'Tunai','Lunas'),
(6,6,'2026-04-15','2026-04',1150000,'Transfer','Lunas'),
(7,7,'2026-04-16','2026-04',1250000,'Tunai','Menunggak'),
(8,8,'2026-04-17','2026-04',1400000,'Transfer','Lunas'),
(9,9,'2026-04-18','2026-04',1500000,'Transfer','Lunas'),
(10,10,'2026-04-19','2026-04',1000000,'Tunai','Lunas');

INSERT INTO Maintenance_Request VALUES
(1,1,1,'2026-04-20','AC rusak','Tinggi','Selesai','Sudah diperbaiki'),
(2,2,2,'2026-04-21','Lampu mati','Sedang','Pengerjaan',NULL),
(3,3,3,'2026-04-22','Air bocor','Tinggi','Selesai','Pipa diganti'),
(4,4,4,'2026-04-23','Wifi lambat','Rendah','Diajukan',NULL),
(5,5,5,'2026-04-24','Kipas rusak','Sedang','Selesai','Diganti'),
(6,6,6,'2026-04-25','Pintu macet','Rendah','Pengerjaan',NULL),
(7,7,7,'2026-04-26','AC bocor','Tinggi','Selesai','Diperbaiki'),
(8,8,8,'2026-04-27','Stop kontak rusak','Sedang','Diajukan',NULL),
(9,9,9,'2026-04-28','Keran bocor','Rendah','Selesai','Diganti'),
(10,10,10,'2026-04-29','Lampu redup','Rendah','Pengerjaan',NULL);

-- 1. Index Tabel Properti
-- Alasan: Pengguna aplikasi atau calon penyewa pasti akan sering menggunakan fitur filter untuk mencari spesifik tipe properti, apakah mereka ingin mencari 'Kos' atau 'Apartemen'.
-- Contoh Query: SELECT * FROM Properti WHERE Tipe_Properti = 'Apartemen';
CREATE INDEX idx_tipe_properti ON Properti(Tipe_Properti);

-- 2. Index Tabel Unit
-- Alasan: Fitur utama dari sistem manajemen properti adalah mengetahui ketersediaan kamar. Sistem akan sangat sering mencari atribut status unit yang bernilai 'Tersedia' untuk ditampilkan ke calon penyewa.
-- Contoh Query: SELECT * FROM Unit WHERE Status_Unit = 'Tersedia';
CREATE INDEX idx_status_unit ON Unit(Status_Unit);

-- 3. Index Tabel Booking
-- Alasan: Pengelola properti butuh dashboard yang bisa langsung memfilter daftar booking yang masih 'Pending' agar bisa segera diputuskan untuk diterima atau ditolak.
-- Contoh Query: SELECT * FROM Booking WHERE Status_Booking = 'Pending';
CREATE INDEX idx_status_booking ON Booking(Status_Booking);

-- 4. Index Tabel Penyewa
-- Alasan: Pengelola sering kali mencari profil penyewa berdasarkan namanya. Atribut Nomor_Identitas tidak perlu di-index manual karena saat di-set UNIQUE, sistem otomatis membuatkannya index.
-- Contoh Query: SELECT * FROM Penyewa WHERE Nama_Penyewa LIKE '%Andi%';
CREATE INDEX idx_nama_penyewa ON Penyewa(Nama_Penyewa);

-- 5. Index Tabel Kontrak_Sewa
-- Alasan: Pengelola harus selalu memantau atribut status kontrak untuk membedakan mana penyewa yang masih 'Aktif' dan mana yang sudah 'Berakhir'.
-- Contoh Query: SELECT * FROM Kontrak_Sewa WHERE Status_Kontrak = 'Aktif';
CREATE INDEX idx_status_kontrak ON Kontrak_Sewa(Status_Kontrak);

-- 6. Index Tabel Pembayaran
-- Alasan: Sistem membutuhkan query harian atau bulanan yang cepat untuk mendeteksi penyewa mana saja yang status pembayarannya 'Menunggak', sehingga sistem bisa otomatis memicu flag peringatan jika sudah lebih dari 2 bulan.
-- Contoh Query: SELECT * FROM Pembayaran WHERE Status_Pembayaran = 'Menunggak';
CREATE INDEX idx_status_pembayaran ON Pembayaran(Status_Pembayaran);

-- 7. Index Tabel Maintenance_Request
-- Alasan: Ini menggunakan Composite Index. Teknisi pasti akan sering mengurutkan atau memfilter data keluhan yang belum dikerjakan ('Diajukan') dan memiliki atribut prioritas 'Tinggi' agar bisa diselesaikan lebih dulu.
-- Contoh Query: SELECT * FROM Maintenance_Request WHERE Status_Request = 'Diajukan' AND Prioritas = 'Tinggi';
CREATE INDEX idx_status_prioritas_maint ON Maintenance_Request(Status_Request, Prioritas);