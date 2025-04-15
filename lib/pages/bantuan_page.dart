import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_home.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Bantuan & Logout", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 8,
                    color: Colors.white.withOpacity(0.92),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.help_outline, color: Colors.teal, size: 28),
                              SizedBox(width: 8),
                              Text(
                                "Panduan Penggunaan",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24, color: Colors.grey),
                          const Text(
                            "1. Login terlebih dahulu menggunakan username & password.\n\n"
                                "2. Di halaman utama tersedia 5 fitur utama:\n"
                                "   • Stopwatch: Jalankan timer.\n"
                                "   • Jenis Bilangan: Cek tipe bilangan.\n"
                                "   • Tracking LBS: Lihat lokasi saat ini.\n"
                                "   • Konversi Waktu: Ubah tahun ke jam/menit/detik.\n"
                                "   • Daftar Situs: Lihat situs rekomendasi.\n\n"
                                "3. Gunakan navigasi bawah untuk berpindah halaman.\n\n"
                                "4. Gunakan tombol logout untuk keluar dari aplikasi.",
                            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
