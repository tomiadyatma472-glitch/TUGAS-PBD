CREATE TABLE Penyewa (
    ID_Penyewa INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Penyewa VARCHAR(100) NOT NULL,
    Nomor_Identitas VARCHAR(50) UNIQUE NOT NULL, -- KTP/Passport dibikin UNIQUE biar ga ada data ganda
    Kontak VARCHAR(20) NOT NULL
)

CREATE TABLE Booking (
    ID_Booking INT AUTO_INCREMENT PRIMARY KEY,
    ID_Penyewa INT NOT NULL,
    ID_Unit INT NOT NULL,
    Tanggal_Booking DATE NOT NULL,
    Jumlah_Deposit DECIMAL(10,2) NOT NULL CHECK (Jumlah_Deposit > 0), -- Business Rule #3
    Status_Booking ENUM('Pending', 'Diterima', 'Ditolak') NOT NULL DEFAULT 'Pending'
)

CREATE TABLE Fasilitas_Unit (
    ID_Unit INT NOT NULL,
    ID_Fasilitas INT NOT NULL,
    PRIMARY KEY (ID_Unit, ID_Fasilitas)
)