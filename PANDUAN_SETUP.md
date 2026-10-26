# Panduan Praktikum Pertemuan 5 - AWS Lambda

Panduan ini mengikuti alur pada video: membuat Lambda HTTP berbasis Node.js, menyajikan `index.html`, membuat Function URL, mengujinya dari browser dan WSL 2, lalu menghapus resource latihan jika sudah selesai.

## Hubungan WSL 2, Lambda, Docker, EC2, dan RDS

- **AWS Lambda** berjalan di infrastruktur AWS. Ubuntu/Kali Linux di WSL 2 hanya menjadi klien untuk mengirim HTTP request menggunakan `curl`; Lambda tidak berjalan di dalam WSL.
- **Docker dan EC2** tidak diperlukan untuk latihan pada video. Keduanya bisa digunakan dalam proyek lain, tetapi tidak perlu dihubungkan agar Function URL ini berfungsi.
- **Amazon RDS** juga tidak diperlukan. Halaman contoh ini tidak menyimpan data ke database.
- Untuk tugas ini, alurnya adalah: `index.html` → dibaca oleh `index.mjs` → di-deploy ke AWS Lambda → diakses dari WSL 2 melalui Function URL.

## Prasyarat

- Akun AWS dan akses ke layanan Lambda.
- WSL 2 dengan Ubuntu atau Kali Linux, terhubung ke internet, dengan `curl` tersedia.
- Browser untuk AWS Console.

Docker, EC2, dan RDS bukan prasyarat untuk mengikuti video ini. Jangan masukkan access key, password, atau data pribadi ke file proyek.

## 1. Buat fungsi Lambda

1. Buka [AWS Lambda Console](https://console.aws.amazon.com/lambda/), pilih region yang akan digunakan (misalnya `ap-southeast-3`), lalu pilih **Create function**.
2. Ikuti video dengan memilih **Use a blueprint** dan blueprint **Getting started with Lambda HTTP** jika tersedia.
3. Beri nama, misalnya `lambda-wsl-tutorial`. Pilih runtime Node.js yang tersedia (video menampilkan `nodejs22.x`) dan arsitektur `x86_64`.
4. Buat fungsi menggunakan execution role default yang disediakan AWS untuk menulis log ke CloudWatch.
5. Pada editor **Code**, pastikan kedua file berikut ada di root paket fungsi dengan nama persis sama:
   - `index.mjs` — salin isi file proyek [index.mjs](./index.mjs).
   - `index.html` — salin isi file proyek [index.html](./index.html).
6. Pastikan handler fungsi adalah `index.handler`, lalu pilih **Deploy**.

`index.mjs` membaca `index.html` dari paket Lambda dan mengembalikannya sebagai respons `text/html`. Jika hanya `index.mjs` yang diunggah, file HTML tidak ditemukan dan fungsi akan gagal.

## 2. Buat Function URL

1. Buka **Configuration** → **Function URL** → **Create function URL**.
2. Pada **Auth type**, pilih `NONE` hanya jika memang perlu diakses publik untuk demonstrasi.
3. Simpan dan salin Function URL yang dibuat AWS. URL ini berbeda untuk setiap fungsi; jangan gunakan URL contoh dari video.

> **Perhatian:** `NONE` membuat endpoint dapat diakses publik oleh siapa pun yang mengetahui URL. Jangan tampilkan atau gunakan URL ini untuk data sensitif. Hapus URL/fungsi setelah demonstrasi jika sudah tidak diperlukan.

## 3. Uji dari browser dan WSL 2

### Browser

Buka Function URL di browser. Halaman harus menampilkan **Hello from AWS Lambda!** dan keterangan bahwa fungsi dipanggil dari Ubuntu/Kali Linux di WSL 2.

### WSL 2

Buka terminal Ubuntu atau Kali Linux, lalu jalankan:

```bash
curl -i "https://<function-id>.lambda-url.<region>.on.aws"
```

Ganti URL dengan URL milik fungsi Anda. Respons yang berhasil memiliki status HTTP `200`, header `Content-Type: text/html`, dan isi HTML yang memuat `Hello from AWS Lambda!`.

Atau, dari direktori proyek yang dapat diakses oleh WSL 2:

```bash
chmod +x test_lambda.sh
./test_lambda.sh "https://<function-id>.lambda-url.<region>.on.aws"
```

Script akan menampilkan informasi sistem WSL dan respons HTTP dari Lambda. Script tidak membuat, mengubah, atau menghapus resource AWS.

## 4. Hapus resource latihan (opsional, sesuai video)

Penghapusan bersifat permanen dan bukan bagian dari pengujian. Lakukan hanya pada fungsi latihan milik Anda setelah tugas selesai:

1. Di halaman fungsi yang benar, pilih **Configuration** → **Function URL**, lalu pilih **Delete**.
2. Ikuti dialog konfirmasi Function URL dan ketik `confirm` jika diminta.
3. Jika ingin menghapus seluruh fungsi, gunakan menu **Actions** → **Delete function**, periksa kembali nama fungsi, lalu selesaikan konfirmasi.

Jangan menghapus EC2, container, atau RDS sebagai bagian dari langkah ini. Video hanya menghapus Function URL dan Lambda function contoh. Periksa kembali region dan nama resource sebelum mengonfirmasi penghapusan.

## File proyek

- [index.mjs](./index.mjs): handler Node.js untuk AWS Lambda.
- [index.html](./index.html): halaman yang dikirim sebagai respons HTTP.
- [test_lambda.sh](./test_lambda.sh): penguji Function URL dari Ubuntu/Kali Linux di WSL 2.

## Troubleshooting

- **Function memberi error saat dijalankan:** pastikan `index.html` ikut di-deploy pada root paket dan handler disetel ke `index.handler`; lalu pilih **Deploy**.
- **Browser/`curl` mendapat 403:** periksa Auth type Function URL dan izin kebijakan terkait. Jangan mengubah izin secara luas; gunakan pengaturan minimum yang diperlukan.
- **`curl` mendapat 404 atau URL tidak merespons:** salin ulang URL dari fungsi yang benar dan pastikan region sesuai.
- **Perubahan belum terlihat:** deploy kembali kode dan tunggu hingga pembaruan fungsi selesai.
