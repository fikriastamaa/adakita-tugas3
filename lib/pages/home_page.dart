import 'package:flutter/material.dart';
import 'stopwatch_page.dart';
import 'jenis_bilangan_page.dart';
import 'tracking_lbs_page.dart';
import 'konversi_waktu_page.dart';
import 'daftar_situs_page.dart';
import 'anggota_page.dart';
import 'bantuan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> bodyPages = [
    HomeMenuPage(),
    AnggotaPage(),
    BantuanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_home.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Scaffold with transparent background
        Scaffold(
          backgroundColor: Colors.transparent, // penting agar tidak menutupi background
          body: bodyPages[_currentIndex],
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              selectedItemColor: Colors.green,
              backgroundColor: Colors.white, // warna ini masih boleh karena di-clip
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.group), label: "Anggota"),
                BottomNavigationBarItem(icon: Icon(Icons.help), label: "Bantuan"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Menu Utama",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuItem(
                    context,
                    title: "Stopwatch",
                    icon: Icons.timer,
                    color: Colors.green,
                    page: StopwatchPage(),
                  ),
                  _buildMenuItem(
                    context,
                    title: "Jenis Bilangan",
                    icon: Icons.calculate,
                    color: Colors.blue,
                    page: JenisBilanganPage(),
                  ),
                  _buildMenuItem(
                    context,
                    title: "Tracking LBS",
                    icon: Icons.location_on,
                    color: Colors.orange,
                    page: TrackingLBSPage(),
                  ),
                  _buildMenuItem(
                    context,
                    title: "Konversi Waktu",
                    icon: Icons.access_time,
                    color: Colors.purple,
                    page: KonversiWaktuPage(),
                  ),
                  _buildMenuItem(
                    context,
                    title: "Daftar Situs",
                    icon: Icons.web,
                    color: Colors.teal,
                    page: DaftarSitusPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required Widget page}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 28,
              child: Icon(icon, size: 30, color: color),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
