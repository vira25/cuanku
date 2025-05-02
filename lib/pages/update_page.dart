import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> transaksi; // Data transaksi yang akan diupdate

  const UpdatePage({super.key, required this.transaksi});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  String tipeTransaksi = 'pemasukan';

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data transaksi yang ada
    tanggalController.text = widget.transaksi['tanggal'];
    namaController.text = widget.transaksi['nama'];
    jumlahController.text = widget.transaksi['jumlah'].toString();
    tipeTransaksi = widget.transaksi['tipe'];
  }

  void updateTransaksi() async {
    final transaksiBaru = {
      'tanggal': tanggalController.text,
      'nama': namaController.text,
      'jumlah': int.parse(jumlahController.text),
      'tipe': tipeTransaksi,
    };

    Navigator.pop(context, transaksiBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Transaksi'), centerTitle: true),
      // Tambahkan konten body di sini jika diperlukan
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tanggal"),
                TextField(
                  controller: tanggalController,
                  decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
                ),
                const SizedBox(height: 20),

                const Text("Nama Transaksi"),
                TextField(controller: namaController),
                const SizedBox(height: 20),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
