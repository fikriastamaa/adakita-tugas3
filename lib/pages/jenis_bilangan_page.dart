import 'package:flutter/material.dart';

class JenisBilanganPage extends StatefulWidget {
  const JenisBilanganPage({super.key});

  @override
  State<JenisBilanganPage> createState() => _JenisBilanganPageState();
}

class _JenisBilanganPageState extends State<JenisBilanganPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _results = [];

  void _cekJenisBilangan() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _results = ['Masukkan angka yang valid.'];
      });
      return;
    }

    List<String> hasil = [];
    bool isInteger = input == input.toInt();

    if (isInteger) {
      int intInput = input.toInt();

      if (intInput == 0) {
        hasil.add('Bilangan Nol');
        hasil.add('Bilangan Cacah');
      } else {
        if (intInput > 0) {
          hasil.add('Bilangan Bulat Positif');
          hasil.add('Bilangan Cacah');
        } else {
          hasil.add('Bilangan Bulat Negatif');
        }

        if (_cekPrima(intInput)) {
          hasil.add('Bilangan Prima');
        }
      }
    } else {
      if (input > 0) {
        hasil.add('Bilangan Desimal Positif');
      } else if (input < 0) {
        hasil.add('Bilangan Desimal Negatif');
      } else {
        hasil.add('Bilangan Nol');
        hasil.add('Bilangan Cacah');
      }
    }

    setState(() {
      _results = hasil;
    });
  }

  void _resetInput() {
    setState(() {
      _controller.clear();
      _results = [];
    });
  }

  bool _cekPrima(int number) {
    if (number <= 1) return false;
    for (int i = 2; i <= number ~/ 2; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Jenis Bilangan"),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Masukkan angka (bisa koma)",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.black.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _cekJenisBilangan,
                  icon: const Icon(Icons.search),
                  label: const Text("Cek Jenis Bilangan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _resetInput,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (_results.isNotEmpty)
              Card(
                elevation: 8,
                color: Colors.white.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _results.map((result) {
                      return Row(
                        children: [
                          const Icon(Icons.info, color: Colors.green, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            result,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
