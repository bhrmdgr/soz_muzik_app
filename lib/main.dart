import 'package:flutter/material.dart';
import 'package:soz_muzik/ana_sayfa.dart';

void main() {
  runApp(const AnaUygulama());
}


class AnaUygulama extends StatelessWidget {
  const AnaUygulama({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnaSayfa(),
    );
  }
}

