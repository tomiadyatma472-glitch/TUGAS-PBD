-- DDL Tabel Properti
CREATE TABLE properti (
    id_properti INT AUTO_INCREMENT PRIMARY KEY,
    id_pengelola INT NOT NULL,
    nama_properti VARCHAR(100) NOT NULL,
    alamat TEXT,
    tipe_properti ENUM('Kos', 'Apartemen'),
);

-- DDL Tabel Maintenance_Request
CREATE TABLE maintenance_request (
    id_request INT AUTO_INCREMENT PRIMARY KEY,
    id_kontrak INT NOT NULL,
    id_teknisi INT,
    tanggal_request DATE NOT NULL,
    deskripsi_kerusakan TEXT NOT NULL,
    prioritas ENUM('Rendah', 'Sedang', 'Tinggi') DEFAULT 'Sedang',
    status_request ENUM('Diajukan', 'Pengerjaan', 'Selesai') DEFAULT 'Diajukan',
    catatan_penyelesaian TEXT,
);
