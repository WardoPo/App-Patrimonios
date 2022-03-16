import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:patrimonios_app/pagina_datos.dart';

class PaginaHostname extends StatefulWidget {
  PaginaHostname();
  @override
  State<StatefulWidget> createState() => _PaginaHostname();
}

class _PaginaHostname extends State<PaginaHostname> {
  //aqui va la consulta
  //hacer la busqueda con el _title
  //

  TextEditingController c_id = TextEditingController();
  String? nohaypapu;
  final CollectionReference usuarios =
      FirebaseFirestore.instance.collection("usuarios");

  buscar() async {
    setState(() {
      nohaypapu = null;
    });

    final DocumentReference document = usuarios.doc(c_id.text);

    try {
      DocumentSnapshot data = await document.get();

      if (data.exists) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PaginaDatos(c_id.text, data: data.data())));
      } else {
        setState(() {
          nohaypapu = "No hay papu";
        });
      }
    } catch (e) {
      setState(() {
        nohaypapu = "No hay server papu";
      });
    }
  }

  agregar() async {
    await usuarios.doc(c_id.text).set({"hostname": "", "ip": "", "nombre": ""});
    buscar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextField(
              controller: c_id,
              decoration: InputDecoration(errorText: nohaypapu),
            ),
            Row(
              children: [
                ElevatedButton(onPressed: buscar, child: Text("Buscar")),
                ElevatedButton(onPressed: agregar, child: Text("Agregar"))
              ],
            )
          ],
        ));
  }
}
