import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cuanku/pages/create_page.dart';
import 'package:cuanku/pages/update_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> daftarTransaksi = [];

  //hitung total pemasukan
  int get totalPemasukan => daftarTransaksi
      .where((transaksi) => transaksi['tipe'] == 'pemasukan')
      .fold(0, (sum, transaksi) => sum + (transaksi['jumlah'] as int));

  //hitung total pengeluaran
  int get totalPengeluaran => daftarTransaksi
      .where((transaksi) => transaksi['tipe'] == 'pengeluaran')
      .fold(0, (sum, transaksi) => sum + (transaksi['jumlah'] as int));

  // Fungsi untuk mengambil data dari database
  Future<void> fetchData() async {
    try {
      final response = await Supabase.instance.client
          .from('uanglalulintas')
          .select()
          .order('tanggal', ascending: false);

      setState(() {
        daftarTransaksi = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Gagal insert: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Ambil data saat pertama kali halaman dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Uang Lalu lintas'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Total Pemasukan: Rp$totalPemasukan'),
              SizedBox(height: 20),
              Text('Total Pengeluaran: Rp$totalPengeluaran'),
              SizedBox(height: 20),
              Expanded(
                child:
                    daftarTransaksi.isEmpty
                        ? Center(child: Text('Belum ada transaksi'))
                        : ListView.builder(
                          itemCount: daftarTransaksi.length,
                          itemBuilder: (context, index) {
                            final isIncome =
                                daftarTransaksi[index]['tipe'] == 'pemasukan';

                            return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(daftarTransaksi[index]['nama']),
                                  Text(
                                    daftarTransaksi[index]['tanggal'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Rp${daftarTransaksi[index]['jumlah']}',
                              ),
                              leading: Icon(
                                isIncome ? Icons.download : Icons.upload,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      // Navigarsi kehalaman update dan tunggu hasilnya
                                      final hasil = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => UpdatePage(
                                                transaksi:
                                                    daftarTransaksi[index],
                                              ),
                                        ),
                                      );
                                      if (hasil != null &&
                                          hasil is Map<String, dynamic>) {
                                        final status = hasil['status'];
                                        final message = hasil['message'];

                                        //Tampilkan pesan menggunakan snackBar
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(message),
                                            backgroundColor:
                                                status == 'success'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        );
                                        if (status == 'success' &&
                                            hasil.containsKey('data')) {
                                          setState(() {
                                            daftarTransaksi[index] =
                                                hasil['data'];
                                          });
                                        } else if (status == 'success') {
                                          await fetchData();
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        daftarTransaksi.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePage()),
          );

          if (hasil != null && hasil is Map<String, dynamic>) {
            setState(() {
              daftarTransaksi.insert(0, hasil);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
