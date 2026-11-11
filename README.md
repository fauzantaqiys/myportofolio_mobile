# myportofolio_mobile

Aplikasi mobile portofolio pribadi berbasis Flutter untuk mata kuliah **Pemrograman Berbasis Platform (CSGE602022)**, Fakultas Ilmu Komputer, Universitas Indonesia, Semester Gasal 2026/2027.

* **Nama**: Fauzan Taqiy Santosa
* **NPM**: 2506607272
* **Kelas**: PBP F

---

## Panduan Menjalankan Aplikasi

1. **Prasyarat**:
   * Flutter SDK (versi 3.x atau terbaru)
   * Dart SDK (sudah ter-bundle di dalam Flutter SDK)
   * Web browser Google Chrome atau Android Emulator / Perangkat fisik Android dengan USB debugging aktif.

2. **Langkah Menjalankan**:
   * Buka terminal di direktori proyek ini:
     ```bash
     cd myportofolio_mobile
     ```
   * Unduh seluruh dependensi proyek:
     ```bash
     flutter pub get
     ```
   * Jalankan aplikasi pada peramban Google Chrome:
     ```bash
     flutter run -d chrome
     ```
   * Untuk memastikan kepatuhan sintaksis dan kualitas kode tanpa isu:
     ```bash
     flutter analyze
     ```

---

### Tugas 7

#### 1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!
* **Pengertian Widget Tree**:
  * Di Flutter, segala sesuatu pada antarmuka pengguna adalah *widget* (prinsip *"everything is a widget"*). *Widget tree* (pohon widget) adalah struktur data hierarkis berbentuk pohon yang merepresentasikan seluruh elemen visual, tata letak (*layout*), interaksi, dan konfigurasi dari aplikasi Flutter.
  * Pohon ini dimulai dari simpul akar (*root widget*), biasanya berupa `MaterialApp` atau `WidgetsApp`, yang kemudian bercabang ke berbagai *container/layout widget*, hingga berakhir pada daun-daun pohon (*leaf widgets*) seperti `Text`, `Icon`, atau elemen visual terkecil lainnya.
* **Hubungan Induk-Anak (*Parent-Child Relationship*)**:
  * Hubungan antarelemen dibangun menggunakan paradigma komposisi (*composition*), bukan pewarisan (*inheritance*). Sebuah widget induk dapat membungkus satu anak (`child`) atau banyak anak (`children`).
  * **Alur Penentuan Ukuran & Posisi (*Constraints Down, Sizes Up, Parent Sets Position*)**:
    1. **Constraints go down**: Widget induk mengoper batasan ukuran (*layout constraints* berupa lebar/tinggi minimum dan maksimum) ke widget anak.
    2. **Sizes go up**: Widget anak merender dirinya sesuai batasan tersebut, menentukan dimensinya sendiri, lalu mengembalikan ukuran aktualnya kepada induk.
    3. **Parent sets position**: Widget induk kemudian mengatur penempatan koordinat spasial (posisi $x, y$) dari widget anak pada layar.
  * Melalui mekanisme ini, pembaruan (*rebuild*) pada simpul tertentu dapat dipropagasi secara efisien ke anak-anaknya tanpa harus merender ulang seluruh komponen aplikasi yang tidak berubah.

---

#### 2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!
Berikut adalah daftar widget yang digunakan dalam proyek ini beserta fungsinya:

1. **`MyApp`**: Widget kelas utama turunan `StatelessWidget` yang berfungsi sebagai titik konfigurasi global aplikasi.
2. **`MaterialApp`**: Widget pembungkus berstandar Material Design yang menyediakan fitur penting seperti tema aplikasi (`theme`), penamaan judul, navigasi, dan routing.
3. **`MyHomePage`**: Widget halaman beranda (`StatelessWidget`) yang menyusun seluruh tata letak halaman portofolio utama.
4. **`Scaffold`**: Widget struktur visual dasar Material Design yang menyediakan kerangka tata letak siap pakai, seperti `appBar` dan `body`.
5. **`AppBar`**: Menampilkan bilah navigasi di bagian paling atas layar yang memuat judul aplikasi (`title`) dan warna latar (`backgroundColor`).
6. **`Text`**: Menampilkan teks ke layar dengan kustomisasi gaya (tipe tulisan, ukuran *font*, ketebalan *font*, dan warna).
7. **`Padding`**: Memberikan jarak ruang kosong di sekeliling widget anaknya agar tampilan tidak menempel ke tepi layar atau elemen lain.
8. **`Column`**: Widget tata letak yang menyusun daftar widget anak (`children`) secara vertikal dari atas ke bawah.
9. **`Row`**: Widget tata letak yang menyusun widget anak secara horizontal sejajar dari kiri ke kanan dengan distribusi spasi tertentu (`MainAxisAlignment.spaceEvenly`).
10. **`Center`**: Menempatkan widget anaknya tepat di tengah area layar atau kontainer yang tersedia.
11. **`SizedBox`**: Memberikan jarak spasial pemisah dengan ukuran tetap (panjang/tinggi tertentu) antar-widget.
12. **`Card`**: Menampilkan kotak bergaya kartu Material dengan sudut membulat dan efek bayangan kedalaman (*elevation*).
13. **`Container`**: Kotak serbaguna yang menggabungkan kemampuan pengaturan dimensi (*width*), *padding*, dan penataan elemen.
14. **`GridView.count`**: Menampilkan kumpulan widget dalam format kisi-kisi (*grid*) dengan jumlah kolom tetap (`crossAxisCount: 3`) serta pengaturan jarak antar-baris dan antar-kolom.
15. **`InfoCard`**: Widget kustom mandiri (*reusable widget*) turunan `StatelessWidget` yang dibuat untuk menampilkan kartu informasi pemilik (NPM, Nama, dan Kelas).
16. **`ItemCard`**: Widget kustom mandiri (*reusable widget*) turunan `StatelessWidget` yang menampilkan tombol menu aksi dengan efek visual klik.
17. **`Material`**: Memberikan permukaan fisik Material Design untuk menerapkan warna latar unik (`color`) dan sudut membulat (`borderRadius`) sehingga efek riak sentuhan dapat terlihat.
18. **`InkWell`**: Menangani interaktivitas sentuhan pengguna (`onTap`) dan memberikan umpan balik visual berupa efek riak air (*ripple effect*).
19. **`Icon`**: Menampilkan grafis simbolik dari pustaka Material Design Icons (seperti `Icons.folder`, `Icons.add_circle`, `Icons.logout`).
20. **`SnackBar`**: Bilah notifikasi visual ringan yang muncul melayang sementara di bagian bawah layar saat tombol menu diklik.

---

#### 3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!
* **Fungsi `MaterialApp`**:
  * Mengintegrasikan pustaka desain Google Material ke dalam aplikasi.
  * Menyediakan pengelolaan tema terpadu (`ThemeData`, `ColorScheme`, tipografi, mode terang/gelap).
  * Menyediakan navigator bawaan (`Navigator`) untuk manajemen rute halaman dan riwayat perpindahan layar (*routing/navigation*).
  * Menyediakan integrasi sistem tingkat tinggi seperti lokalisasi bahasa (i18n), arah penulisan teks (*text directionality* LTR/RTL), dan inspeksi dimensi layar perangkat (`MediaQuery`).
* **Mengapa Menjadi *Root Widget***:
  * Widget-widget turunan Material Design (seperti `Scaffold`, `AppBar`, `Card`, `SnackBar`, `TextField`, dan dialog) membutuhkan objek konteks dan tema yang disediakan oleh `MaterialApp` melalui *InheritedWidget*.
  * Jika sebuah aplikasi langsung menggunakan widget Material tanpa dibungkus `MaterialApp`, aplikasi akan mengalami error runtime karena komponen visual kehilangan definisi tema, navigasi, dan konteks Material.

---

#### 4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?
* **Perbedaan Utama**:
  | Aspek | `StatelessWidget` | `StatefulWidget` |
  |---|---|---|
  | **Sifat Data (*State*)** | *Immutable* (tidak berubah sepanjang waktu setelah dibuat). | *Mutable* (dapat berubah secara dinamis selama masa hidup aplikasi). |
  | **Struktur Kelas** | Terdiri dari 1 kelas yang mengimplementasikan metode `build()`. | Terdiri dari 2 kelas: kelas widget itu sendiri dan kelas `State<T>` pendamping. |
  | **Mekanisme Rebuild** | Hanya di-rebuild jika widget induk memberikan konfigurasi/parameter baru. | Dapat di-rebuild secara mandiri kapan saja dengan memanggil fungsi `setState()`. |
  | **Beban Kinerja** | Sangat ringan, efisien, dan cepat dialokasikan di memori. | Membutuhkan alokasi memori tambahan untuk mengelola siklus hidup objek `State`. |

* **Kapan Menggunakan Masing-Masing**:
  * **Pilih `StatelessWidget`**: Saat tampilan antarmuka bersifat statis, hanya bergantung pada konfigurasi awal yang dioperkan via konstruktor, dan tidak perlu memutasi data lokal secara internal. Contoh: halaman profil statis, label teks, ikon, kartu ringkasan informasi, dan tombol navigasi statis.
  * **Pilih `StatefulWidget`**: Saat tampilan antarmuka perlu bereaksi secara dinamis terhadap tindakan pengguna atau peristiwa eksternal. Contoh: form isian input teks, *checkbox*, pengalihan tombol *switch*, pemutaran animasi, *counter*, atau data yang dimuat secara asinkronus dari server/API.

---

#### 5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?
* **Pengertian `BuildContext`**:
  * `BuildContext` adalah objek referensi (*handle*) yang merepresentasikan lokasi atau posisi spesifik suatu widget di dalam hierarki *widget tree*.
  * Setiap widget memiliki `BuildContext`-nya masing-masing yang unik terhadap simpul tempatnya berada.
* **Mengapa Penting**:
  * `BuildContext` menjadi jembatan bagi widget untuk berinteraksi dengan lingkungan sekitarnya. Melalui `context`, sebuah widget dapat melakukan penelusuran ke atas pohon (*ancestor lookup*) untuk mengakses data bersama yang disediakan oleh *InheritedWidget*, misalnya:
    * Mengambil palet warna atau gaya tema: `Theme.of(context)`.
    * Membaca informasi ukuran dan orientasi layar: `MediaQuery.of(context)`.
    * Mengontrol dan menampilkan bilah notifikasi: `ScaffoldMessenger.of(context)`.
    * Melakukan perpindahan halaman: `Navigator.of(context)`.
* **Penggunaannya di dalam Metode `build`**:
  * `BuildContext` diterima sebagai parameter wajib pada tanda tangan metode `Widget build(BuildContext context)`.
  * Parameter ini digunakan di dalam badan fungsi untuk membaca konfigurasi dinamis yang sesuai dengan lokasi widget tersebut. Contoh pada proyek ini:
    * `MediaQuery.of(context).size.width / 3.5`: Mengambil lebar layar aktual perangkat agar kartu `InfoCard` proporsional.
    * `ScaffoldMessenger.of(context)..showSnackBar(...)`: Menemukan scaffold terdekat untuk menampilkan `SnackBar`.

---

#### 6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?
* **Konsep *Hot Reload***:
  * Fitur canggih pada lingkungan pengembangan Flutter yang memanfaatkan kapabilitas kompilasi *Just-In-Time* (JIT) dari Dart Virtual Machine (VM).
  * *Hot Reload* bekerja dengan menginjeksi berkas kode sumber yang baru dimodifikasi secara langsung ke memori Dart VM yang sedang berjalan, lalu membangun ulang pohon widget (*rebuild widget tree*) tanpa mematikan aplikasi.
  * Keunggulan utamanya: proses pembaruan berjalan dalam hitungan milidetik dan **mempertahankan nilai *state* aplikasi yang sedang berjalan** (misalnya, teks yang sudah diketik di form atau nilai variabel internal tidak akan hilang).
* **Perbedaan dengan *Hot Restart***:
  * *Hot Reload*: Mengupdate antarmuka dengan mempertahankan *state* lokal yang ada.
  * *Hot Restart*: Memuat ulang seluruh basis kode dan **menghancurkan serta mereset seluruh *state* aplikasi kembali ke kondisi inisial (awal)**, kemudian mengeksekusi ulang fungsi `main()`.
* **Kapan Tidak Bisa Mengandalkan *Hot Reload***:
  * **Perubahan pada fungsi `main()`**: Perubahan inisialisasi aplikasi tingkat teratas tidak dapat dieksekusi ulang via *Hot Reload*.
  * **Modifikasi metode `initState()` pada `StatefulWidget`**: Karena `initState()` hanya dipanggil satu kali saat objek `State` pertama kali dibuat, perubahan di dalamnya membutuhkan *Hot Restart*.
  * **Perubahan struktur model data atau tipe variabel global/statis**: Misalnya mengubah tipe data dari `int` menjadi `String`, yang menyebabkan inkonsistensi memori *state* lama.
  * **Perubahan pada berkas manifes `pubspec.yaml`**: Menambahkan *dependency* pustaka baru atau mendeklarasikan aset gambar/font baru memerlukan kompilasi ulang penuh (*Full Restart*).
  * **Perubahan kode native**: Modifikasi berkas konfigurasi Android (`build.gradle`, `AndroidManifest.xml`) atau iOS (`Info.plist`, pod files) memerlukan *Full Restart/Rebuild*.

---

### Pernyataan Penggunaan AI (AI Disclosure)

Dalam pengerjaan Individual Assignment 7 ini, kecerdasan buatan (AI) digunakan sebagai alat bantu pengembangan dengan rincian transparansi sebagai berikut:

* **Alat / Model AI yang Digunakan**:
  * Antigravity AI Coding Assistant yang ditenagai oleh model **Google Gemini 3.8 Flash**.
* **Strategi Prompting**:
  * **Pemberian Konteks Bertahap**: Memberikan dokumen spesifikasi tugas resmi (`tugas-7.pdf`) untuk diekstrak daftar kebutuhan (*checklist minimal*) dan rubrik penilaian yang berlaku.
  * **Dekomposisi Tugas (*Step-by-Step Execution*)**: Menginstruksikan AI untuk membagi pengerjaan ke dalam tahapan-tahapan kecil yang modular (Bagian 1: Data Identitas Diri, Bagian 2: Model & Kustomisasi Warna Tombol, Bagian 3: Pertanyaan Reflektif & Dokumentasi), di mana setiap tahapan diverifikasi menggunakan `flutter analyze` sebelum dilakukan *commit* dan *push*.
* **Bagian Spesifik yang Dibantu oleh AI**:
  1. Melakukan pemeriksaan diagnostik sistem pengembangan via `flutter doctor` dan `flutter devices`.
  2. Memandu refaktorisasi arsitektur kode dari pola bawaan ke pemisahan file modular (`main.dart` dan `menu.dart`).
  3. Membantu formulasi teknis jawaban reflektif mengenai cara kerja internal framework Flutter (*widget tree constraints*, *BuildContext*, serta arsitektur kompilasi Dart VM pada *Hot Reload*).
* **Telaah Kritis Keterbatasan AI & Koreksi Manual yang Dilakukan**:
  * *Keterbatasan*: Jika tidak diinstruksikan secara tegas, AI cenderung menyelesaikan seluruh tugas dalam satu langkah besar (*single monolithic edit*) dan mengabaikan disiplin Git bertahap yang dinilai pada rubrik.
  * *Koreksi/Intervensi*: Penulis secara aktif mengendalikan alur kerja dengan mewajibkan pendekatan *incremental commit* dengan format *Conventional Commits*, memastikan penerapan warna tombol menggunakan pendekatan *Object-Oriented Programming* (properti `Color` pada model) daripada percabangan `if-else` yang rapuh, serta memvalidasi kesesuaian NPM, Nama, dan Kelas agar benar-benar mencerminkan identitas mahasiswa yang bersangkutan.
