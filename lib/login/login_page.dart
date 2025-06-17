import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; //untuk koneksi ke supabase
import 'package:cuanku/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController =
      TextEditingController(); // untuk input email
  final TextEditingController passwordController =
      TextEditingController(); // untuk input password

  bool tampilkanPassword =
      false; // untuk mengatur apakah password ditampilkan atau tidak
  bool isLoading = false; // untuk menandai apakah proses login sedang berjalan

  void login() async {
    final email =
        emailController.text.trim(); // ambil input email dan hapus spasi
    final password =
        passwordController.text.trim(); // ambil input password dan hapus spasi

    //Validasi: cek apakah email dan password tidak kosong
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Login Galal'),
              content: const Text('Email dan password tidak boleh kosong.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // tutup dialog
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return; // hentikan proses login jika ada yang kosong
    }
    // Validasi: cek apakah email mengandung simbol '@'
    if (!email.contains('@')) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Email Tidak Valid'),
              content: const Text(
                'Email tidak valid. Pastikan mengandung simbol @.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // tutup dialog
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return; // hentikan proses login jika email tidak valid
    }
    // mulai proses login
    setState(() {
      isLoading = true; // tampilkan loading saat proses login
    });
    try {
      // proses login ke supabase  menggunakan email & password
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // jika login berhasil dan user tidak null, navigasi ke halaman Home
      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      // jika terjadi error, tampilkan pesan error
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Login Gagal'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // tutup dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      setState(() {
        isLoading = false; // sembunyikan loading setelah proses selesai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800, //Latar belakang gelap
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // kolom sesuaikan dengan isinya
            children: [
              const Text(
                'Hallo Ayooo Login Yaaa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24), //jarak vertikal
              //Input Email
              TextField(
                controller: emailController, // ambil input email
                decoration: const InputDecoration(
                  labelText: 'Emial',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              //input Password
              TextField(
                controller: passwordController,
                obscureText:
                    !tampilkanPassword, // sembunyikan jika tidak ditampilkan
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      tampilkanPassword
                          ? Icons.visibility
                          : Icons.visibility_off, //  ikon mata terbuka/tutup
                    ),
                    onPressed: () {
                      setState(() {
                        tampilkanPassword = !tampilkanPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              //tombol login
              SizedBox(
                width: double.infinity, // tombol selebar form
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : login, // nonaktifkan tombol saat loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, //warna tombol
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Colors.white,
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                            color: Colors.white, // Loading saat proses login
                          )
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
