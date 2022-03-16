import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginaEscaneo extends StatefulWidget {
  final String id;
  PaginaEscaneo(this.id);

  @override
  State<StatefulWidget> createState() => _PaginaEscaneo();
}

class _PaginaEscaneo extends State<PaginaEscaneo> {
  //TODO: Replace Text Editing Controller with Barcode Scanner
  TextEditingController c_barcode = TextEditingController();

  final barcode_pattern = RegExp(r'([0-9]{8}[0-9]{4})');

  //TODO Replace FAB with response from BarcodeScanner
  agregar() async {
    String barcode = c_barcode.text;

    //barcode = barcode_pattern.firstMatch(barcode).toString().substring(0, 7);

    DocumentSnapshot<Map<String, dynamic>> coincidence =
        await FirebaseFirestore.instance
            .collection("coincidencias")
            .doc(barcode.substring(0, 8)) //TODO: Fix with Regex
            .get();

    //TODO: Add to collection if item does not exist

    if (coincidence.exists) {
      await FirebaseFirestore.instance
          .collection('usuarios/${widget.id}/perifericos')
          .doc(barcode)
          .set({
        "descripcion": coincidence.data()?["descripcion"],
        "id": barcode
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: c_barcode,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: agregar,
        child: Icon(Icons.add),
      ),
    );
  }
}
