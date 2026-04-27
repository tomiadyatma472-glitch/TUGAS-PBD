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