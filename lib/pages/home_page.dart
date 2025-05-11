import 'package:flutter/material.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cuanku/pages/create_page.dart';
import 'package:cuanku/pages/update_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> daftarTransaksi = [
    {
      'id': 1,
      'nama': 'Gaji Pertama',
      'tanggal': '2025-04-02',
      'jumlah': 5000000,
      'tipe': 'pemasukan',
    },
    {
      'id': 2,
      'nama': 'Belanja',
      'tanggal': '2025-04-03',
      'jumlah': 150000,
      'tipe': 'pengeluaran',
    },
    {
      'id': 3,
      'nama': 'Gaji Kedua',
      'tanggal': '2025-05-02',
      'jumlah': 10000000,
      'tipe': 'pemasukan',
    },
  ];

  int get totalPemasukan => daftarTransaksi
      .where((transaksi) => transaksi['tipe'] == 'pemasukan')
      .fold(0, (sum, transaksi) => sum + (transaksi['jumlah'] as int));

  int get totalPengeluaran => daftarTransaksi
      .where((transaksi) => transaksi['tipe'] == 'pengeluaran')
      .fold(0, (sum, transaksi) => sum + (transaksi['jumlah'] as int));

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
                                        setState(() {
                                          daftarTransaksi[index] = hasil;
                                        });
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
              daftarTransaksi.add(hasil);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
