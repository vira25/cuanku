import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  String tipeTransaksi = 'pemasukan';

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

  Future<void> _simpanTransaksi() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response =
            await Supabase.instance.client.from('uanglalulintas').insert({
              'tanggal': tanggalController.text,
              'nama': namaController.text,
              'tipe': tipeTransaksi,
              'jumlah': int.parse(jumlahController.text),
            }).select();

        if (!mounted) return;
        if (response.isNotEmpty) {
          Navigator.pop(context, response.first);
        }
      } catch (e) {
        debugPrint('Gagal menyimpan transaksi: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Transaksi"), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_update.jpg'),
            fit: BoxFit.cover, // biar background nutup seluruh layar
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40, // jarak dari atas & bawah
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: tanggalController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: const InputDecoration(
                          labelText: "Tanggal (YYYY-MM-DD)",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Tanggal tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: "Nama Transaksi",
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Nama tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: tipeTransaksi,
                        decoration: const InputDecoration(
                          labelText: "Tipe Transaksi",
                          border: OutlineInputBorder(),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: jumlahController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Jumlah",
                          border: OutlineInputBorder(),
                        ),
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
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _simpanTransaksi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            "Simpan",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
