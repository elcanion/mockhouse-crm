import 'dart:convert';

/* Devo alterar esse import para universal_html em versões futuras */
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

String master = 'master@master.com';
String admin = 'admin@admin.com';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> loadcsv() async {
    var picked = await FilePicker.platform.pickFiles();
    var fileBytes;
    if (picked != null) {
      fileBytes = picked.files.first.bytes;
    }
    String bar = latin1.decode(fileBytes);
    List<List<dynamic>> csv = CsvToListConverter(
      eol: "\n",
      fieldDelimiter: ';',
      textDelimiter: '"',
    ).convert(bar);

    for (var i = 0; i < csv.length; i++) {
      FirebaseFirestore.instance.collection('leads').add({
        'codCliente': csv[i][0].toString(),
        'nome': csv[i][1].toString(),
        'telefone': csv[i][2].toString(),
        'email': csv[i][3].toString(),
        'situacao': csv[i][4].toString(),
        'detalhes': csv[i][5].toString(),
        'emailCorretor': csv[i][6].toString(),
      });
    }
  }

  void createcsv() async {
    var snapshot = await FirebaseFirestore.instance.collection('leads').get();
    var leads = snapshot.docs.map((e) => e.data());
    for (var lead in leads) {
      print(lead['nome']);
    }
    List<List<dynamic>> rows = [];
    for (var lead in leads) {
      List<dynamic> row = [];
      row.add(lead['codCliente']);
      row.add(lead['nome']);
      row.add(lead['telefone']);
      row.add(lead['email']);
      row.add(lead['situacao']);
      row.add(lead['detalhes']);
      row.add(lead['emailCorretor']);
      rows.add(row);
    }
    rows.sort((a, b) => a.toString().compareTo((b.toString())));
    print(rows);
    String csv = const ListToCsvConverter(
      eol: "\n",
      fieldDelimiter: ';',
      textDelimiter: '"',
    ).convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "leads.csv")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String currentName = user!.displayName.toString();
    String currentEmail = user.email.toString();
    return Drawer(
        child: ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 10,
      ),
      IconButton(onPressed: () {}, icon: Icon(Icons.account_circle)),
      ListTile(
        title: Center(child: Text(currentName)),
        subtitle: Center(child: Text(currentEmail)),
      ),
      TextButton(
        onPressed: () {
          if (user.email == master || user.email == admin) {
            loadcsv();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Função disponível apenas para o administrador'),
            ));
          }
        },
        child: Text('Ler .csv'),
      ),
      TextButton(
        onPressed: () {
          if (user.email == master || user.email == admin) {
            createcsv();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Função disponível apenas para o administrador'),
            ));
          }
        },
        child: Text('Exportar .csv'),
      ),
      TextButton(
          onPressed: () {
            _signOut();
          },
          child: Text('Sair da conta')),
    ]));
  }
}

class DesktopDrawer extends StatefulWidget {
  const DesktopDrawer({Key? key}) : super(key: key);

  @override
  _DesktopDrawerState createState() => _DesktopDrawerState();
}

class _DesktopDrawerState extends State<DesktopDrawer> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String currentName = user!.displayName.toString();
    String currentEmail = user.email.toString();
    return Drawer(
        child: ListView(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 10,
      ),
      IconButton(onPressed: () {}, icon: Icon(Icons.account_circle)),
      ListTile(
        title: Center(child: Text(currentName)),
        subtitle: Center(child: Text(currentEmail)),
      ),
      TextButton(
          onPressed: () {
            _signOut();
          },
          child: Text('Sair da conta')),
    ]));
  }
}
