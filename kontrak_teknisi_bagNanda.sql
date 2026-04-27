-- ======================================
-- KONTRAK_SEWA & TEKNISI
-- ======================================

-- =========================
-- DDL (CREATE TABLE)
-- =========================

CREATE TABLE kontrak_sewa (
    id_kontrak INT AUTO_INCREMENT PRIMARY KEY,
    id_booking INT NOT NULL, 
    tanggal_mulai DATE NOT NULL,
    tanggal_berakhir DATE NOT NULL,
    harga_sewa DECIMAL(10,2) NOT NULL,
    status_kontrak ENUM('Aktif', 'Berakhir', 'Diperpanjang') NOT NULL
);

CREATE TABLE teknisi (
    id_teknisi INT AUTO_INCREMENT PRIMARY KEY,
    nama_teknisi VARCHAR(100) NOT NULL,
    keahlian VARCHAR(100) NOT NULL
);