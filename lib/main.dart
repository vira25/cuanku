import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cuanku/pages/home_page.dart';

const String supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjYWJ1cGp4YnRqZndwYmh5ZGxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4OTIwOTgsImV4cCI6MjA2MDQ2ODA5OH0.bJBSjGUqPSezshoeN5D-IGU0dpUT3zskyPhyVPOWdD8';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ecabupjxbtjfwpbhydlo.supabase.co',
    anonKey: supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cuanku yey',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
