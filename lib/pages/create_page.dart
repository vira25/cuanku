import 'package:flutter/material.dart';
// import "package:cuanku/pages/create_page.dart";

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController tangggalController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  String tipeTransaksi = 'pemasukan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Transaksi"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          // untuk memberikan warna background
          color: Colors.blue[50],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tanggal"),
                  TextField(
                    controller: tangggalController,
                    decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
                  ),
                  const SizedBox(height: 16),
                  const Text("Nama Transaksi"),
                  TextField(controller: namaController),
                  const SizedBox(height: 16),
                  const Text("Tipe Transaksi"),
                  RadioListTile(
                    title: const Text('pemasukan'),
                    value: 'pemasukan',
                    groupValue: tipeTransaksi,
                    onChanged: (value) {
                      setState(() {
                        tipeTransaksi = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('pengeluaran'),
                    value: 'pengeluaran',
                    groupValue: tipeTransaksi,
                    onChanged: (value) {
                      setState(() {
                        tipeTransaksi = value.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("jumlah"),
                  TextField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final transaksiBaru = {
                          'tanggal': tangggalController.text,
                          'nama': namaController.text,
                          'tipe': tipeTransaksi,
                          'jumlah': int.parse(jumlahController.text),
                        };
                        Navigator.pop(context, transaksiBaru);
                      },
                      child: const Text("Simpan"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
