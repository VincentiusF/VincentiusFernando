import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController npmController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController visiController = TextEditingController();

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(
    'mahasiswa',
  );

  Future<void> simpanData() async {
    final data = {
      'npm': npmController.text.trim(),
      'nama': namaController.text.trim(),
      'visi': visiController.text.trim(),
    };

    try {
      final String key = dbRef.push().key ?? '';
      if (key.isEmpty) throw Exception("Key kosong");

      await dbRef.child(key).set(data);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Data berhasil disimpan")));

      // Reset form
      npmController.clear();
      namaController.clear();
      visiController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Gagal menyimpan: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Biodata Mahasiswa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: npmController,
              decoration: const InputDecoration(labelText: "NPM"),
            ),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: visiController,
              decoration: const InputDecoration(labelText: "Visi 5 Tahun"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: simpanData,
              child: const Text("Simpan Data"),
            ),
          ],
        ),
      ),
    );
  }
}
