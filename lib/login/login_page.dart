import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // untuk koneksi ke Supabase
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

  bool tampilkanPassword = false;
  bool isLoading = false; // untuk menandai apakah proses login sedang berjalan

  void login() async {
    final email = emailController.text.trim(); // ambil input email
    final password = passwordController.text.trim(); // ambil input password

    // Validasi: cek apakah email dan password tidak kosong
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Login Gagal'),
              content: const Text('Email dan password tidak boleh kosong.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // Validasi: cek format email
    if (!email.contains('@')) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Email Tidak Valid'),
              content: const Text('Pastikan email mengandung simbol @.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // Mulai proses login
    setState(() {
      isLoading = true;
    });

    try {
      // Proses login ke Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Jika login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      // Jika login gagal
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Login Gagal'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // agar gambar memenuhi layar
        children: [
          // 🖼️ Background Gambar + Gradasi
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_login.jpg'),
                fit: BoxFit.cover, // gambar menutupi seluruh layar
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE3F2FD), // biru muda
                  Color(0xFFFFFFFF), // putih lembut
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🌫️ Lapisan transparan agar teks/form tetap terbaca
          Container(color: Colors.white.withOpacity(0.2)),

          // ✨ Form Login di tengah layar
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Hallo, Ayoo Login Dulu 💙',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Password
                  TextField(
                    controller: passwordController,
                    obscureText: !tampilkanPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          tampilkanPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
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

                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
