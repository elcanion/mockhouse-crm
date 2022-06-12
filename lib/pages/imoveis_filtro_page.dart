import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mockhouse_crm/models/imovel.dart';
import 'package:mockhouse_crm/pages/imoveis_add_page.dart';
import 'package:mockhouse_crm/pages/user_drawer.dart';
import 'package:mockhouse_crm/widgets/imovel_card.dart';

class ImoveisFiltroPage extends StatefulWidget {
  const ImoveisFiltroPage({Key? key}) : super(key: key);

  @override
  State<ImoveisFiltroPage> createState() => _ImoveisFiltroPageState();
}

class _ImoveisFiltroPageState extends State<ImoveisFiltroPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<String> tipoImovel = [
    'Apartamento',
    'Casa',
    'Sobrado',
    'Casa de Condomínio',
    'Sobrado de Condomínio',
    'Terreno',
    'Cobertura',
    'Lote',
    'Chácara',
    'Sítio',
    'Fazenda',
    'Kitnet',
    'Prédio',
    'Ponto Comercial',
    'Loja',
    'Hotel-Flat'
  ].toList();

  @override
  void initState() {
    _tabController = TabController(length: tipoImovel.length, vsync: this);
    super.initState();
  }

  adicionarImovel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ImoveisAddPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var snapshots =
        FirebaseFirestore.instance.collection('imoveis').snapshots();

    return Scaffold(
      drawer: UserDrawer(),
      appBar: AppBar(
        title: Text('Imóveis'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                adicionarImovel();
              },
              icon: Icon(Icons.add)),
        ],
        bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: List<Widget>.generate(tipoImovel.length, (int index) {
              //return SizedBox(                  height: 25, child: new Text(situacoes[index].toString()));
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(tipoImovel[index].toString()),
              );
            })),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: snapshots,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Alguma coisa deu errado');
            } else if (snapshot.hasData || snapshot.data != null) {
              return TabBarView(
                  controller: _tabController,
                  children:
                      List<Widget>.generate(tipoImovel.length, (int index) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var imovelInfo = snapshot.data!.docs[i];
                          String docID = snapshot.data!.docs[i].id;

                          Imovel imovel = Imovel(
                              endereco: imovelInfo['endereco'],
                              proprietario: imovelInfo['proprietario'],
                              telefone: imovelInfo['telefone'],
                              email: imovelInfo['email'],
                              valor: imovelInfo['valor'],
                              tamanho: imovelInfo['tamanho'],
                              areaUtil: imovelInfo['areaUtil'],
                              quartos: imovelInfo['quartos'],
                              banheiros: imovelInfo['banheiros'],
                              nMatricula: imovelInfo['nMatricula'],
                              situacao: imovelInfo['situacao'],
                              habitse: imovelInfo['habitse'],
                              escritura: imovelInfo['escritura'],
                              exclusividade: imovelInfo['exclusividade'],
                              parceiros: imovelInfo['parceiros'],
                              corretorResponsavel:
                                  imovelInfo['corretorResponsavel'],
                              agendaDefinida: imovelInfo['agendaDefinida'],
                              agenda: imovelInfo['agenda'].toDate(),
                              imagemDefinida: imovelInfo['imagemDefinida'],
                              imagemUrl: imovelInfo['imagemUrl'],
                              imagemNome: imovelInfo['imagemNome'],
                              observacao: imovelInfo['observacao'],
                              tipoImovel: imovelInfo['tipoImovel'],
                              docId: docID);

                          if (imovelInfo['tipoImovel'] == tipoImovel[index]) {
                            return ImovelCardTwo(
                              imovel: imovel,
                            );
                          }
                          return Offstage(
                            offstage: true,
                            child: Text(''),
                          );
                        });
                  }));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
