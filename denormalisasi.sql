
-- DENORMALISASI SISTEM PROPERTYHUB
-- Kelompok 5 - Pemrograman Basis Data


USE propertyhub_db;


-- BAGIAN 1: STORING DERIVED DATA


ALTER TABLE Kontrak_Sewa
ADD COLUMN Total_Sudah_Dibayar DECIMAL(15,2) NOT NULL DEFAULT 0
COMMENT 'Kolom denormalisasi: total akumulasi pembayaran, diperbarui otomatis via trigger';

-- Inisialisasi nilai Total_Sudah_Dibayar dari data Pembayaran yang sudah ada
UPDATE Kontrak_Sewa k
SET k.Total_Sudah_Dibayar = (
    SELECT COALESCE(SUM(py.Jumlah_Bayar), 0)
    FROM Pembayaran py
    WHERE py.ID_Kontrak = k.ID_Kontrak
);

-- Trigger: Perbarui Total_Sudah_Dibayar setiap kali ada pembayaran baru
DELIMITER $$
CREATE TRIGGER trg_after_insert_pembayaran
AFTER INSERT ON Pembayaran
FOR EACH ROW
BEGIN
    UPDATE Kontrak_Sewa
    SET Total_Sudah_Dibayar = Total_Sudah_Dibayar + NEW.Jumlah_Bayar
    WHERE ID_Kontrak = NEW.ID_Kontrak;
END$$
DELIMITER ;

-- Trigger: Perbarui Total_Sudah_Dibayar jika jumlah pembayaran diubah
DELIMITER $$
CREATE TRIGGER trg_after_update_pembayaran
AFTER UPDATE ON Pembayaran
FOR EACH ROW
BEGIN
    UPDATE Kontrak_Sewa
    SET Total_Sudah_Dibayar = Total_Sudah_Dibayar - OLD.Jumlah_Bayar + NEW.Jumlah_Bayar
    WHERE ID_Kontrak = NEW.ID_Kontrak;
END$$
DELIMITER ;

-- Trigger: Kurangi Total_Sudah_Dibayar jika data pembayaran dihapus
DELIMITER $$
CREATE TRIGGER trg_after_delete_pembayaran
AFTER DELETE ON Pembayaran
FOR EACH ROW
BEGIN
    UPDATE Kontrak_Sewa
    SET Total_Sudah_Dibayar = Total_Sudah_Dibayar - OLD.Jumlah_Bayar
    WHERE ID_Kontrak = OLD.ID_Kontrak;
END$$
DELIMITER ;



-- BAGIAN 2: ATRIBUT NON-KEY + SHORT CIRCUIT KEY



ALTER TABLE Maintenance_Request
ADD COLUMN Nama_Penyewa VARCHAR(100) NULL
    COMMENT 'Atribut Non-Key: nama penyewa, disalin dari tabel Penyewa via trigger',
ADD COLUMN ID_Unit INT NULL
    COMMENT 'Short Circuit Key: kunci pintas ke tabel Unit, disalin dari tabel Booking via trigger';

-- Inisialisasi nilai Nama_Penyewa dan ID_Unit dari data yang sudah ada
UPDATE Maintenance_Request mr
JOIN Kontrak_Sewa k  ON mr.ID_Kontrak = k.ID_Kontrak
JOIN Booking b       ON k.ID_Booking  = b.ID_Booking
JOIN Penyewa p       ON b.ID_Penyewa  = p.ID_Penyewa
SET
    mr.Nama_Penyewa = p.Nama_Penyewa,
    mr.ID_Unit      = b.ID_Unit;

-- Trigger: Isi otomatis Nama_Penyewa dan ID_Unit saat maintenance request baru dibuat
DELIMITER $$
CREATE TRIGGER trg_before_insert_maintenance
BEFORE INSERT ON Maintenance_Request
FOR EACH ROW
BEGIN
    DECLARE v_Nama_Penyewa VARCHAR(100);
    DECLARE v_ID_Unit      INT;

    -- Tarik Nama_Penyewa dan ID_Unit melalui rantai relasi:
    -- Kontrak_Sewa -> Booking -> Penyewa & Unit
    SELECT p.Nama_Penyewa, b.ID_Unit
    INTO v_Nama_Penyewa, v_ID_Unit
    FROM Kontrak_Sewa k
    JOIN Booking b ON k.ID_Booking = b.ID_Booking
    JOIN Penyewa p ON b.ID_Penyewa = p.ID_Penyewa
    WHERE k.ID_Kontrak = NEW.ID_Kontrak
    LIMIT 1;

    SET NEW.Nama_Penyewa = v_Nama_Penyewa;
    SET NEW.ID_Unit      = v_ID_Unit;
END$$
DELIMITER ;



-- VERIFIKASI HASIL DENORMALISASI


-- Verifikasi Skenario 1: Query monitoring pembayaran SESUDAH denormalisasi
-- (Tidak lagi membutuhkan JOIN ke Pembayaran atau SUM/GROUP BY)
SELECT
    p.Nama_Penyewa,
    k.Status_Kontrak,
    k.Total_Sudah_Dibayar
FROM Penyewa p
JOIN Booking b       ON p.ID_Penyewa  = b.ID_Penyewa
JOIN Kontrak_Sewa k  ON b.ID_Booking  = k.ID_Booking
WHERE k.Status_Kontrak = 'Aktif';

-- Verifikasi Skenario 2: Query maintenance request SESUDAH denormalisasi
-- (Tidak lagi membutuhkan JOIN ke Kontrak_Sewa, Booking, Penyewa, dan Unit)
SELECT
    mr.ID_Request,
    mr.Deskripsi_Kerusakan,
    mr.Prioritas,
    mr.Nama_Penyewa,
    mr.ID_Unit,
    t.Nama_Teknisi
FROM Maintenance_Request mr
LEFT JOIN Teknisi t ON mr.ID_Teknisi = t.ID_Teknisi
WHERE mr.Status_Request != 'Selesai';
