import 'package:flutter/material.dart';
import "package:cuanku/pages/create_page.dart";

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(title: const Text("Tambah Transalsi")));
}
