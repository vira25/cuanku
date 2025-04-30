import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
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

    int totalIncome = transactions
        .where((transaction) => transaction['tipe'] == 'pemasukan')
        .fold(0, (sum, transaction) => sum + (transaction['jumlah'] as int));

    int totalExpense = transactions
        .where((transaction) => transaction['tipe'] == 'pengeluaran')
        .fold(0, (sum, transaction) => sum + (transaction['jumlah'] as int));

    return Scaffold(
      appBar: AppBar(
        title: Text('Uang Lalu lintas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
            // onPressed: () {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => const Createpage()),
            //   );
            // },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Total Pemasukan: Rp$totalIncome'),
              SizedBox(height: 20),
              Text('Total Pengeluaran: Rp$totalExpense'),
              SizedBox(height: 20),
              Expanded(
                child:
                    transactions.isEmpty
                        ? Center(child: Text('Belum ada transaksi'))
                        : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final isIncome =
                                transactions[index]['tipe'] == 'pemasukan';

                            return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(transactions[index]['nama']),
                                  Text(
                                    transactions[index]['tanggal'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Rp${transactions[index]['jumlah']}',
                              ),
                              leading: Icon(
                                isIncome ? Icons.download : Icons.upload,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {},
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
    );
  }
}
