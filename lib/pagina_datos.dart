import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patrimonios_app/pagina_escaneo.dart';

class PaginaDatos extends StatefulWidget {
  final dynamic data;
  final String id;
  PaginaDatos(this.id, {this.data});

  @override
  State<StatefulWidget> createState() => _PaginaDatosState();
}

class _PaginaDatosState extends State<PaginaDatos> {
  bool editable = false;

  bool is_new = false;

  late TextEditingController c_hostname, c_ip, c_nombre;
  late IconButton edit, save;

  late DocumentReference usuario;

  late Stream<List<Map>> perifericos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    usuario = FirebaseFirestore.instance.collection("usuarios").doc(widget.id);

    perifericos = usuario
        .collection("perifericos")
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());

    c_hostname = TextEditingController(text: widget.data["hostname"]);
    c_ip = TextEditingController(text: widget.data["ip"]);
    c_nombre = TextEditingController(text: widget.data["nombre"]);

    edit = IconButton(onPressed: editar, icon: Icon(Icons.edit));
    save = IconButton(onPressed: guardar, icon: Icon(Icons.save));
  }

  editar() {
    setState(() {
      editable = true;
    });
  }

  guardar() async {
    dynamic data = {
      "hostname": c_hostname.text,
      "ip": c_ip.text,
      "nombre": c_nombre.text
    };

    await usuario.set(data);

    setState(() {
      editable = false;
    });
  }

  agregar_periferico() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PaginaEscaneo(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id),
        actions: [editable ? save : edit],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                TextField(controller: c_hostname, readOnly: !editable),
                TextField(controller: c_ip, readOnly: !editable),
                TextField(controller: c_nombre, readOnly: !editable)
              ],
            ),
          ),
          StreamBuilder<List<Map>>(
              stream: perifericos,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                      child: LinearProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data != null) {
                    List<Map> perifericos = snapshot.data!;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((_, index) {
                        final periferico = perifericos[index];
                        return ListTile(
                          title: Text("${periferico["id"]}"),
                          subtitle: Text(
                            "${periferico["descripcion"]}",
                          ),
                        );
                      }, childCount: perifericos.length),
                    );
                  }
                }

                return SliverToBoxAdapter();
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: agregar_periferico,
        child: Icon(Icons.devices_other),
      ),
    );
  }
}
