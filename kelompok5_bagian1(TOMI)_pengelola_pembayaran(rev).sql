-- ============================================================
--  PropertyHub – Sistem Manajemen Properti (Kos / Apartemen)
--  Kelompok 5 | Perancangan Basis Data
--  Bagian 1: Tabel_Pengelola & Tabel_Pembayaran
-- ============================================================


-- ============================================================
--  DDL – Tabel_Pengelola
-- ============================================================
-- Menyimpan data penanggung jawab properti.
-- Relasi logis: Pengelola (1) → (M) Properti
-- ============================================================

CREATE TABLE Tabel_Pengelola (
    ID_Pengelola    INT             NOT NULL AUTO_INCREMENT,
    Nama_Pengelola  VARCHAR(100)    NOT NULL,
    Nomor_Kontak    VARCHAR(20)     NOT NULL,
    Dibuat_Pada     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Diperbarui_Pada TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (ID_Pengelola),
    UNIQUE KEY uq_pengelola_kontak (Nomor_Kontak)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Menyimpan data pengelola / penanggung jawab properti';


-- ============================================================
--  DDL – Tabel_Pembayaran
-- ============================================================
-- Mencatat setiap transaksi pembayaran sewa bulanan penyewa.
--
-- Business Rules yang diterapkan:
--  BR-1  Jumlah_Bayar harus > 0
--  BR-2  Metode hanya: 'Transfer' atau 'Tunai'
--  BR-3  Status_Pembayaran hanya: 'Lunas' atau 'Menunggak'
--  BR-5  Periode_Bulan wajib diisi dengan format YYYY-MM
-- ============================================================

CREATE TABLE Tabel_Pembayaran (
    ID_Pembayaran       INT             NOT NULL AUTO_INCREMENT,
    Tanggal_Pembayaran  DATE            NOT NULL,
    Periode_Bulan       CHAR(7)         NOT NULL,
    Jumlah_Bayar        DECIMAL(15, 2)  NOT NULL,
    Metode              ENUM('Transfer', 'Tunai')
                                        NOT NULL,
    Status_Pembayaran   ENUM('Lunas', 'Menunggak')
                                        NOT NULL DEFAULT 'Menunggak',
    Dibuat_Pada         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Diperbarui_Pada     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (ID_Pembayaran),

    -- BR-1: Jumlah_Bayar harus positif
    CONSTRAINT chk_jumlah_bayar_positif
        CHECK (Jumlah_Bayar > 0),

    -- Format Periode_Bulan: YYYY-MM
    CONSTRAINT chk_format_periode
        CHECK (Periode_Bulan REGEXP '^[0-9]{4}-(0[1-9]|1[0-2])$')

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Mencatat pembayaran sewa bulanan per kontrak';


-- ============================================================
--  INDEX – Tabel_Pengelola
-- ============================================================

-- Untuk fitur search pengelola berdasarkan nama di dashboard admin
-- Query: SELECT * FROM Tabel_Pengelola WHERE Nama_Pengelola LIKE 'Budi%';
CREATE INDEX idx_pengelola_nama
    ON Tabel_Pengelola (Nama_Pengelola);


-- ============================================================
--  INDEX – Tabel_Pembayaran
-- ============================================================

-- Laporan pembayaran bulanan
-- Query: SELECT * FROM Tabel_Pembayaran WHERE Periode_Bulan = '2025-04';
CREATE INDEX idx_pembayaran_periode
    ON Tabel_Pembayaran (Periode_Bulan);

-- Deteksi tunggakan
-- Query: SELECT * FROM Tabel_Pembayaran WHERE Status_Pembayaran = 'Menunggak';
CREATE INDEX idx_pembayaran_status
    ON Tabel_Pembayaran (Status_Pembayaran);

-- Rekap penerimaan kas harian
-- Query: SELECT * FROM Tabel_Pembayaran WHERE Tanggal_Pembayaran = '2025-04-10';
CREATE INDEX idx_pembayaran_tanggal
    ON Tabel_Pembayaran (Tanggal_Pembayaran);


-- ============================================================
--  DML – INSERT DATA SAMPEL: Tabel_Pengelola
-- ============================================================

INSERT INTO Tabel_Pengelola
    (ID_Pengelola, Nama_Pengelola, Nomor_Kontak)
VALUES
    (1, 'Budi Santoso',      '08112345678'),
    (2, 'Siti Rahayu',       '08223456789'),
    (3, 'Ahmad Fauzi',       '08334567890'),
    (4, 'Dewi Kurniawati',   '08445678901'),
    (5, 'Rizky Pratama',     '08556789012');


-- ============================================================
--  DML – INSERT DATA SAMPEL: Tabel_Pembayaran
-- ============================================================

INSERT INTO Tabel_Pembayaran
    (ID_Pembayaran, Tanggal_Pembayaran, Periode_Bulan, Jumlah_Bayar,
     Metode, Status_Pembayaran)
VALUES
    -- 3 bulan lunas via Transfer
    ( 1, '2025-02-01', '2025-02', 2500000.00, 'Transfer', 'Lunas'),
    ( 2, '2025-03-02', '2025-03', 2500000.00, 'Transfer', 'Lunas'),
    ( 3, '2025-04-01', '2025-04', 2500000.00, 'Transfer', 'Lunas'),

    -- Bulan 02 lunas, bulan 03-04 menunggak
    ( 4, '2025-02-05', '2025-02', 3000000.00, 'Tunai',    'Lunas'),
    ( 5, '2025-03-15', '2025-03', 3000000.00, 'Transfer', 'Menunggak'),
    ( 6, '2025-04-20', '2025-04', 3000000.00, 'Transfer', 'Menunggak'),

    -- Semua lunas via transfer selama 4 bulan
    ( 7, '2025-01-10', '2025-01', 1800000.00, 'Transfer', 'Lunas'),
    ( 8, '2025-02-10', '2025-02', 1800000.00, 'Transfer', 'Lunas'),
    ( 9, '2025-03-10', '2025-03', 1800000.00, 'Transfer', 'Lunas'),
    (10, '2025-04-10', '2025-04', 1800000.00, 'Transfer', 'Lunas'),

    -- Satu bulan lunas, satu menunggak
    (11, '2025-03-07', '2025-03', 4500000.00, 'Transfer', 'Lunas'),
    (12, '2025-04-12', '2025-04', 4500000.00, 'Tunai',    'Menunggak'),

    -- Tunai semua, lunas selama 3 bulan
    (13, '2025-02-20', '2025-02', 2200000.00, 'Tunai',    'Lunas'),
    (14, '2025-03-20', '2025-03', 2200000.00, 'Tunai',    'Lunas'),
    (15, '2025-04-21', '2025-04', 2200000.00, 'Tunai',    'Lunas');


-- ============================================================
-- END OF FILE
-- ============================================================
