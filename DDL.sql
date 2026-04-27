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