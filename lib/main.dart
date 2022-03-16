import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:patrimonios_app/pagina_hostname.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: PaginaHostname()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController hostname = TextEditingController();

  final firebase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Busqueda"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(
              height: 120,
            ),
            TextField(
              controller: hostname,
              decoration: InputDecoration(
                  labelText: "Usuario de red",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(
              height: 120,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => PaginaHostname()));
                    },
                    child: const Text("Buscar")),
                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () {
                      //agregar();
                      hostname.clear();
                    },
                    child: const Text("Agregar")),
              ],
            ),
          ]),
        ));
  }
}
