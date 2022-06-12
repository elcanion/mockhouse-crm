import 'package:flutter/material.dart';
import 'package:mockhouse_crm/pages/user_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ProprietariosPage extends StatelessWidget {
  const ProprietariosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var snapshots =
        FirebaseFirestore.instance.collection('imoveis').snapshots();

    return Scaffold(
        drawer: UserDrawer(),
        appBar: AppBar(
          title: Text('Proprietários'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: snapshots,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Alguma coisa deu errado');
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var imovelInfo = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(
                            '${imovelInfo['proprietario']} - ${imovelInfo['nMatricula']}'),
                        subtitle: Text(imovelInfo['telefone']),
                        trailing: IconButton(
                            onPressed: () =>
                                launch("tel://${imovelInfo['telefone']}"),
                            icon: Icon(Icons.phone)),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
