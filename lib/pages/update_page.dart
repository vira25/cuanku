import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> transaksi; // Data transaksi yang akan diupdate

  const UpdatePage({super.key, required this.transaksi});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController tangggalController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  String tipeTransaksi = 'pemasukan';

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data transaksi yang ada
    tangggalController.text = widget.transaksi['tanggal'];
    namaController.text = widget.transaksi['nama'];
    jumlahController.text = widget.transaksi['jumlah'].toString();
    tipeTransaksi = widget.transaksi['tipe'];
  }

  void updateTransaksi() async {
    final transaksiBaru = {
      'tanggal': tangggalController.text,
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
    );
  }
}
