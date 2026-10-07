import 'package:flutter/material.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';

void main() {
  runApp(const DebuggingApp());
}

class DebuggingApp extends StatelessWidget {
  const DebuggingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 16: Debugging Challenge',
      theme: ThemeData(
        // PERBAIKAN: Hapus kata kunci 'const' sebelum Color(...)
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const DebugChallengePage(),
    );
  }
}

class DebugChallengePage extends StatefulWidget {
  const DebugChallengePage({super.key});

  @override
  State<DebugChallengePage> createState() => _DebugChallengePageState();
}

class _DebugChallengePageState extends State<DebugChallengePage> {
  // Flag pencegah navigasi ganda (Kasus D)
  bool _isNavigating = false;

  Future<void> _safeNavigateToDetail() async {
    if (_isNavigating) return; // Mencegah multiple push

    setState(() => _isNavigating = true);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DummyDetailPage(),
      ),
    );

    if (mounted) {
      setState(() => _isNavigating = false); // Buka kembali kunci setelah kembali
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Tahap 16: Debugging Lab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      // Solusi Kasus C: Menggunakan SingleChildScrollView agar aman saat keyboard muncul
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Identitas Mahasiswa
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.blue.shade100,
                        // Fallback aman jika file gambar profil belum tersedia
                        backgroundImage: const AssetImage('assets/images/profile.jpeg'),
                        onBackgroundImageError: (_, __) {},
                        child: const Icon(Icons.person, color: Colors.blueGrey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studentName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'NIM: $studentId',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= KASUS A: SOLUSI RENDERFLEX OVERFLOW =================
              _buildSectionCard(
                title: 'Kasus A: Text Panjang dalam Row',
                subtitle: 'Solusi: Bungkus teks dengan Expanded agar teks otomatis wrap.',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$studentId - $studentName - Teks ini sangat panjang dan berpotensi memicu RenderFlex Overflow jika tidak dibungkus dengan widget Expanded secara tepat.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= KASUS B: SOLUSI UNBOUNDED HEIGHT =================
              _buildSectionCard(
                title: 'Kasus B: ListView di dalam Column',
                subtitle: 'Solusi: Bungkus ListView dengan SizedBox terbatas atau Expanded.',
                child: Container(
                  height: 140, // Memberikan bounded constraint pada ListView
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.check_circle_outline, size: 18),
                      title: Text('Data Item Terbatas #${index + 1}'),
                      subtitle: Text('SKS Topik: ${(index + 1) * 2} • $studentId'),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= KASUS D: SOLUSI NAVIGASI GANDA =================
              _buildSectionCard(
                title: 'Kasus D: Penanganan Navigasi Ganda',
                subtitle: 'Solusi: Mengunci pemanggilan Navigator dengan state flag pemblokir.',
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: _isNavigating ? null : _safeNavigateToDetail,
                    icon: _isNavigating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward),
                    label: Text(
                      _isNavigating ? 'Memproses Route...' : 'Buka Halaman (Aman Multi-tap)',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= KASUS C: SOLUSI KEYBOARD OVERFLOW =================
              _buildSectionCard(
                title: 'Kasus C: Input di Bagian Bawah Layar',
                subtitle: 'Solusi: Halaman dibungkus SingleChildScrollView sehingga fleksibel saat keyboard terbuka.',
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Klik untuk memunculkan keyboard virtual',
                    hintText: 'Perhatikan UI tetap dapat di-scroll...',
                    prefixIcon: const Icon(Icons.keyboard),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
            const Divider(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class DummyDetailPage extends StatelessWidget {
  const DummyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Halaman Tunggal'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 50, color: Colors.teal),
              const SizedBox(height: 12),
              const Text(
                'Halaman Hanya Terbuka Satu Kali!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text('Diverifikasi oleh: $studentName ($studentId)'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}