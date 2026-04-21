import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const RecordsPage()));
}

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
