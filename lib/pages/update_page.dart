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
      // Mengupdate data transaksi di Supabase
      final response =
          await Supabase.instance.client
              .from('uanglalulintas') // nama tabel di Supabase
              .update(transaksiBaru) // data yang akan diupdate
              .eq(
                'id',
                widget.transaksi['id'],
              ) // id transaksi yang akan diupdate
              .select(); // untuk mendapatkan data yang sudah diupdate

      if (!mounted) return; // mencegah eror saat menggunakan context
      if (response.isNotEmpty) {
        Navigator.pop(context, {
          // kembali ke halaman sebelumnya
          'status': 'success', // status sukses
          'message': 'Transaksi berhasil diupdate', // pesan sukses
          'data': response.first, // data transaksi yang sudah diupdate
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // ukuran padding sekitar konten
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap:
                      () =>
                          _selectDate(context), // buka date picker saat diklik
                  child: AbsorbPointer(
                    child: TextField(
                      controller:
                          tanggalController, // controller untuk text field tanggal
                      decoration: const InputDecoration(
                        labelText: "Tanggal",
                        border: OutlineInputBorder(
                          // border untuk text field
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ), // sudut melengkung
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ), // sudut melengkung saat fokus
                          borderSide: BorderSide(color: Colors.blue),
                        ), // warna border saat fokus
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // jarak antar elem
                TextField(
                  controller:
                      namaController, // controller untuk text field nama transaksi
                  decoration: const InputDecoration(
                    labelText: "Nama Transaksi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ), // sudut melengkung
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ), // sudut melengkung saat fokus
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ), // warna border saat fokus
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: tipeTransaksi,
                  decoration: InputDecoration(
                    labelText: "Tipe Transaksi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'pemasukan',
                      child: Text('Pemasukan'),
                    ),
                    DropdownMenuItem(
                      value: 'pengeluaran',
                      child: Text('Pengeluaran'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tipeTransaksi = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),

                TextField(
                  controller:
                      jumlahController, // controller untuk text field jumlah
                  keyboardType:
                      TextInputType.number, // keyboard untuk input angka
                  decoration: const InputDecoration(
                    // dekorasi text field jumlah
                    labelText: "Jumlah",
                    border: OutlineInputBorder(
                      // border untuk text field
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ), // sudut melengkung
                    ),
                    focusedBorder: OutlineInputBorder(
                      // sudut melengkung saat fokus
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ), // sudut melengkung saat fokus
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ), // warna border saat fokus
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol untuk simpan
                Center(
                  child: ElevatedButton(
                    onPressed: updateTransaksi, // fungsi untuk update transaksi
                    child: const Text("Simpan"), // teks pada tombol
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
