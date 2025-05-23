import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import "package:cuanku/pages/create_page.dart";

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>(); // untuk validasi semua inputan form

  final TextEditingController tanggalController =
      TextEditingController(); //mengatur input taggal
  final TextEditingController namaController =
      TextEditingController(); //mengatur input nama
  final TextEditingController jumlahController =
      TextEditingController(); //mengatur input jumlah

  String tipeTransaksi = 'pemasukan';

  //Fungsi untuk membuka date picker dan menyimpan tanggal ke controller
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  // untuk menyimpan data transaksi ke database/supabases
  Future<void> _simpanTransaksi() async {
    if (_formKey.currentState!.validate()) {
      //untuk mengecek apakah semua inputan sudah benar
      try {
        final response =
            await Supabase.instance.client.from('uanglalulintas').insert({
              'tanggal': tanggalController.text,
              'nama': namaController.text,
              'tipe': tipeTransaksi,
              'jumlah': int.parse(jumlahController.text),
            }).select();
        if (!mounted) return; // mencegah eror saat menggunakan context
        if (response.isNotEmpty) {
          Navigator.pop(
            context,
            response.first,
          ); // kembali ke halaman sebelumnya (homePage)
        }
      } catch (e) {
        debugPrint(
          'Gagal menyimpan transaksi: $e',
        ); //menampilkan pesan eror jika gagal insert
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Transaksi"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          // untuk memberikan warna pada background
          color: Colors.blue[50],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tanggal"),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: tanggalController,
                          decoration: const InputDecoration(
                            hintText: "YYYY-MM-DD",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Nama Transaksi"),
                    TextFormField(
                      controller: namaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
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
                    TextFormField(
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Jumlah harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _simpanTransaksi,
                        child: const Text("Simpan"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
