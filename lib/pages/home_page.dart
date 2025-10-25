import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cuanku/pages/create_page.dart';
import 'package:cuanku/pages/update_page.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🧮 Variabel untuk menyimpan data keuangan
  int saldo = 0;
  int totalPemasukan = 0;
  int totalPengeluaran = 0;
  List<Map<String, dynamic>> daftarTransaksi = [];

  int _selectedIndex = 0; // 👉 Indeks untuk navigasi bawah (BottomNavBar)

  @override
  void initState() {
    super.initState();
    fetchData(); // ✅ Panggil fungsi ambil data saat halaman dibuka
  }

  // 🔄 Ambil data dari tabel Supabase
  Future<void> fetchData() async {
    try {
      final response = await Supabase.instance.client
          .from('uanglalulintas')
          .select()
          .order('id', ascending: false);

      final List data = response as List;

      int pemasukan = 0;
      int pengeluaran = 0;

      // 💰 Hitung total pemasukan dan pengeluaran
      for (var item in data) {
        if (item['tipe'] == 'pemasukan') {
          pemasukan += item['jumlah'] as int;
        } else {
          pengeluaran += item['jumlah'] as int;
        }
      }

      setState(() {
        daftarTransaksi = data.cast<Map<String, dynamic>>();
        totalPemasukan = pemasukan;
        totalPengeluaran = pengeluaran;
        saldo = pemasukan - pengeluaran;
      });
    } catch (e) {
      print("Error fetchData: $e");
    }
  }

  // 🔘 Fungsi ketika item navigasi bawah ditekan
  void _onItemTapped(int index) async {
    if (index == 1) {
      // 👉 Jika tombol tambah ditekan
      final hasil = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePage()),
      );
      if (hasil == true) {
        fetchData(); // 🔁 Refresh data setelah menambah transaksi
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 👤 Jika tab Profil dipilih
    if (_selectedIndex == 2) {
      return Scaffold(
        appBar: AppBar(title: Text("Profil"), centerTitle: true),
        body: Container(
          // 🎨 Tambahkan background image di halaman Profil juga
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_home.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 100, color: Colors.blueGrey),
                SizedBox(height: 20),
                Text(
                  "Nama Pengguna",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Berhasil logout")));
                  },
                  child: Text("Logout"),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      );
    }

    // 🏠 Halaman utama (Home)
    return DefaultTabController(
      length: 2, // ada 2 tab: Transaksi & Laporan
      child: Scaffold(
        appBar: AppBar(
          title: Text('Uang Lalu Lintas'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [Tab(text: "Transaksi Harian"), Tab(text: "Laporan Bulanan")],
          ),
        ),

        // 🎨 Tambahkan background di seluruh body halaman
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bg_hompage.jpg',
              ), // 🔹 path gambar bg
              fit: BoxFit.cover, // 🔹 agar memenuhi layar
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 💵 Card Saldo (informasi saldo utama)
                Card(
                  elevation: 4,
                  color: Colors.green.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(12),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Saldo Kamu",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Rp$saldo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.account_balance_wallet,
                          size: 50,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // 💰 Total pemasukan & pengeluaran
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Colors.blue.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Pemasukan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Rp $totalPemasukan',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: Colors.red.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Pengeluaran',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Rp $totalPengeluaran',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // 📊 Konten TabBar (transaksi & laporan)
                Expanded(
                  child: TabBarView(
                    children: [
                      // TAB 1: Riwayat transaksi
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Riwayat Transaksi",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child:
                                  daftarTransaksi.isEmpty
                                      ? Center(
                                        child: Text('Belum ada transaksi'),
                                      )
                                      : ListView.builder(
                                        itemCount: daftarTransaksi.length,
                                        itemBuilder: (context, index) {
                                          final isIncome =
                                              daftarTransaksi[index]['tipe'] ==
                                              'pemasukan';
                                          return Card(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    daftarTransaksi[index]['nama'],
                                                  ),
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
                                                isIncome
                                                    ? Icons.download
                                                    : Icons.upload,
                                                color:
                                                    isIncome
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                              trailing: Wrap(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                    ),
                                                    onPressed: () async {
                                                      final hasil =
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => UpdatePage(
                                                                    transaksi:
                                                                        daftarTransaksi[index],
                                                                  ),
                                                            ),
                                                          );
                                                      if (hasil != null &&
                                                          hasil
                                                              is Map<
                                                                String,
                                                                dynamic
                                                              >) {
                                                        await fetchData();
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      final id =
                                                          daftarTransaksi[index]['id'];
                                                      await Supabase
                                                          .instance
                                                          .client
                                                          .from(
                                                            'uanglalulintas',
                                                          )
                                                          .delete()
                                                          .eq('id', id);
                                                      fetchData();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                            ),
                          ],
                        ),
                      ),

                      // TAB 2: Grafik laporan bulanan
                      Center(
                        child: PieChart(
                          dataMap: {
                            "Pemasukan": totalPemasukan.toDouble(),
                            "Pengeluaran": totalPengeluaran.toDouble(),
                          },
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.bottom,
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  // ⚙️ Bottom Navigation Bar
  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 35, color: Colors.green),
          label: 'Tambah',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
