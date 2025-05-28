import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    // Edit dengan data yang sudah ada
    tanggalController.text = widget.transaksi['tanggal'];
    namaController.text = widget.transaksi['nama'];
    jumlahController.text = widget.transaksi['jumlah'].toString();
    tipeTransaksi = widget.transaksi['tipe'];
  }

  Future<void> _selectDate(BuildContext context) async {
    //utuk memilih tanggal dari date picker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(tanggalController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        tanggalController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void updateTransaksi() async {
    final transaksiBaru = {
      'tanggal': tanggalController.text,
      'nama': namaController.text,
      'jumlah': int.parse(jumlahController.text),
      'tipe': tipeTransaksi,
    };

    try {
      final response =
          await Supabase.instance.client
              .from('uanglalulintas')
              .update(transaksiBaru)
              .eq('id', widget.transaksi['id'])
              .select();

      if (!mounted) return; // mencegah eror saat menggunakan context
      if (response.isNotEmpty) {
        Navigator.pop(context, {
          'status': 'success',
          'message': 'Transaksi berhasil diupdate',
          'data': response.first,
        });
      }
    } catch (e) {
      debugPrint('Gagal update transaksi: $e');

      if (mounted) {
        //kirim pesan gagal ke homapage
        Navigator.pop(context, {
          'status': 'error',
          'message': 'Gagal update transaksi',
        });
      }
      // Navigator.pop(context, transaksiBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Transaksi'), centerTitle: true),
      // Tambahkan konten body di sini jika diperlukan
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50], // warna backgorund
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tanggal"),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: tanggalController,
                        decoration: const InputDecoration(
                          hintText: "YYYY-MM-DD",
                        ),
                      ),
                    ),
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
                  const SizedBox(height: 20),

                  const Text("Jumlah"),
                  TextField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: updateTransaksi,
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
