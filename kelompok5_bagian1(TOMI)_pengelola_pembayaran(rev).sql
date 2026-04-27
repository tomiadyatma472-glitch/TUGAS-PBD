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



