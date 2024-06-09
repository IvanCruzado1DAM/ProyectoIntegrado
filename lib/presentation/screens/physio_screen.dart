import 'package:flutter/material.dart';

class PhysioScreen extends StatelessWidget {
  const PhysioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Physio Screen')),
      body: Center(child: const Text('Physio Screen')),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue, // Color de fondo de la barra
        child: Container(
          height: 50, // Altura de la barra
          alignment: Alignment.center, // Alineación del texto
          child: const Text(
            'MEDICAL PART',
            style: TextStyle(
              color: Colors.white, // Color del texto
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
