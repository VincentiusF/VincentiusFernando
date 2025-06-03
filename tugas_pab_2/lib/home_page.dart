import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController npmController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController visiController = TextEditingController();

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(
    'mahasiswa',
  );

  late AnimationController _glowController;
  late Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = ColorTween(
      begin: Colors.pink.shade400,
      end: Colors.deepPurple.shade400,
    ).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    npmController.dispose();
    namaController.dispose();
    visiController.dispose();
    super.dispose();
  }

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD16BA5), Color(0xFF8B5FBF), Color(0xFF5B86E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                width: 400,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 2,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildShimmerTitle("Input Biodata Mahasiswa"),
                      const SizedBox(height: 28),
                      _buildGlassTextField(
                        controller: npmController,
                        label: "NPM",
                        icon: Icons.confirmation_number_outlined,
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 22),
                      _buildGlassTextField(
                        controller: namaController,
                        label: "Nama",
                        icon: Icons.person_outline,
                        inputType: TextInputType.name,
                      ),
                      const SizedBox(height: 22),
                      _buildGlassTextField(
                        controller: visiController,
                        label: "Visi 5 Tahun",
                        icon: Icons.visibility_outlined,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 36),

                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return GestureDetector(
                            onTapDown: (_) => setState(() => _isPressed = true),
                            onTapUp: (_) => setState(() => _isPressed = false),
                            onTapCancel:
                                () => setState(() => _isPressed = false),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 150),
                              scale: _isPressed ? 0.96 : 1,
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _glowAnimation.value!.withOpacity(
                                        0.65,
                                      ),
                                      blurRadius: 18,
                                      spreadRadius: 3,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _glowAnimation.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: simpanData,
                                  child: Text(
                                    "Simpan Data",
                                    style: GoogleFonts.poppins(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isPressed = false;

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.22),
                Colors.white.withOpacity(0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1.4,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLines,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white70),
              labelText: label,
              labelStyle: GoogleFonts.poppins(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerTitle(String text) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [
                Colors.white.withOpacity(0.4 + 0.6 * value),
                Colors.white.withOpacity(0.1 + 0.4 * value),
              ],
              stops: [0.0, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(rect);
          },
          child: child,
        );
      },
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: Colors.white,
          shadows: const [
            Shadow(offset: Offset(0, 2), blurRadius: 8, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
