import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/situs_data.dart';

class DaftarSitusPage extends StatefulWidget {
  const DaftarSitusPage({super.key});

  @override
  State<DaftarSitusPage> createState() => _DaftarSitusPageState();
}

class _DaftarSitusPageState extends State<DaftarSitusPage> {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      daftarSitus[index].isFavorite = !daftarSitus[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Daftar Situs Rekomendasi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: daftarSitus.length,
          itemBuilder: (context, index) {
            final situs = daftarSitus[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.2), // Bayangan lebih soft
              color: Colors.white.withOpacity(0.8), // Transparansi card untuk latar belakang lebih lembut
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    situs.gambarUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,  // Menjaga gambar agar tidak terpotong
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 40);
                    },
                  ),
                ),
                title: Text(
                  situs.namaSitus,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  situs.url,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        situs.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: situs.isFavorite ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorite(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: () => _launchURL(situs.url),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
