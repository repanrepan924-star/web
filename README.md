# Portal Pengaduan Warga Kelurahan

Website satu halaman untuk menerima dan mengelola laporan/pengaduan warga di tingkat kelurahan. Warga mengisi formulir, mendapat nomor tiket, lalu petugas dapat memantau dan mengubah status laporan (Menunggu → Diproses → Selesai) lewat halaman yang sama.

## Isi folder

```
portal-pengaduan-kelurahan/
├── index.html   ← seluruh website (HTML, CSS, JS jadi satu file)
└── README.md    ← panduan ini
```

## Cara membuka

Cukup buka `index.html` langsung di browser (klik dua kali), atau upload folder ini ke layanan hosting statis apa pun:

- **GitHub Pages** — upload folder ke repo, aktifkan Pages, arahkan ke `index.html`.
- **Netlify / Vercel** — seret folder ini ke dashboard "deploy" mereka.
- **Server kelurahan / komputer lokal** — cukup taruh folder ini di web server (Apache/Nginx) atau buka langsung dari file explorer.

Tidak ada proses instalasi, tidak butuh internet, tidak butuh database eksternal.

## Tentang penyimpanan data

Website ini awalnya dibuat sebagai *artifact* di Claude.ai, yang menyediakan penyimpanan otomatis (`window.storage`) sehingga data laporan tersimpan dan bisa dilihat bersama oleh siapa pun yang membuka artifact tersebut.

Setelah dijadikan file mandiri seperti ini (dibuka langsung di browser atau di-hosting sendiri), fitur `window.storage` **tidak tersedia**. Konsekuensinya:

- Website tetap berfungsi penuh selama sesi berjalan (kirim laporan, ubah status, lihat rekap).
- Data akan **hilang saat halaman di-refresh atau ditutup**, karena belum ada database sungguhan di baliknya.

### Supaya data tersimpan permanen dan bisa diakses dari luar

Untuk pemakaian nyata di kelurahan, sambungkan formulir ke penyimpanan sungguhan, misalnya:

1. **Supabase** (sudah dipersiapkan di kode ini) — paling cepat untuk website statis. Datanya bisa diakses dari mana saja, dan admin bisa menerima atau menolak laporan dari panel admin.
2. **Firebase** — sama-sama cocok untuk aplikasi web realtime, lalu admin membaca dari database yang sama.
3. **Backend sendiri** (MySQL/PostgreSQL di server kelurahan) — cocok jika ingin login petugas dan hak akses berjenjang.
4. **Formulir pihak ketiga** (Google Form) yang hasilnya diringkas manual di halaman rekap.

### Cara aktifkan Supabase

1. Buat project di Supabase.
2. Buka SQL Editor dan jalankan isi file `supabase.sql`.
3. Buka Project Settings → API.
4. Salin `Project URL` dan `anon/public key`.
5. Edit blok berikut di file `index.html`:

```html
<script>
  window.SUPABASE_CONFIG = {
    url: 'https://your-project.supabase.co',
    anonKey: 'your-anon-key'
  };
</script>
```

6. Setelah itu, masuk ke Supabase → Authentication → Users.
7. Buat akun admin (contoh: admin@kelurahan.go.id) dengan email/password.
8. Setelah akun dibuat, jalankan SQL untuk menambahkan akun itu ke tabel `public.admin_users`:

```sql
insert into public.admin_users (user_id, email, nama, is_active)
select au.id, au.email, 'Admin Kelurahan', true
from auth.users au
where au.email = 'admin@kelurahan.go.id';
```

9. Simpan file, lalu buka situs di browser. Login di panel admin untuk menerima atau menolak laporan.

Catatan: kode ini tetap punya mode fallback lokal (`localStorage`) agar Anda bisa demo tanpa koneksi database.

## Menyesuaikan isi

Beberapa hal yang mudah diganti langsung di `index.html`:

- **Nama kelurahan**: cari teks "Kelurahan Sukamaju" di bagian kop surat, ganti sesuai nama kelurahan Anda.
- **Kategori laporan**: cari `<select id="f-kategori">` dan `<select id="filter-kategori">`, tambah/ubah pilihan `<option>` di keduanya secara bersamaan.
- **Warna & tampilan**: semua warna diatur di bagian `:root { ... }` paling atas file (variabel seperti `--pine`, `--rust`, `--gold`).
