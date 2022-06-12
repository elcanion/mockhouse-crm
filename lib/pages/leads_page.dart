import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockhouse_crm/models/lead.dart';
import 'package:mockhouse_crm/pages/leads_add_page.dart';
import 'package:mockhouse_crm/pages/leads_update_page_adm.dart';
import 'package:mockhouse_crm/pages/leads_update_page_regular.dart';
import 'package:mockhouse_crm/pages/main_page.dart';
import 'package:mockhouse_crm/pages/user_drawer.dart';

String master = 'master@master.com';
String admin = 'admin@admin.com';

class LeadsPage extends StatelessWidget {
  const LeadsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return DesktopLeadsPage();
      } else {
        return MobileLeadsPage();
      }
    });
  }
}

class MobileLeadsPage extends StatefulWidget {
  const MobileLeadsPage({Key? key}) : super(key: key);

  @override
  _MobileLeadsPageState createState() => _MobileLeadsPageState();
}

class _MobileLeadsPageState extends State<MobileLeadsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<String> situacoes = [
    'Sem Acionamento',
    'Retornar mais tarde',
    //'Qualificado',
    'Interesse em Venda',
    'Interesse em Compra',
    'Captação',
    'Em negociação',
    'Fechado',
    'Sem interesse',
    'Não atende',
    'Telefone inexistente',
    'Outros',
  ].toList();

  @override
  void initState() {
    _tabController = TabController(length: situacoes.length, vsync: this);
    super.initState();
  }

  adicionarLead(user) {
    if (user.email == master || user.email == admin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LeadsAddPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LeadsAddPage()),
      );
    }
  }

  Future<void> editarLead(Lead lead, user) async {
    if (user.email == master || user.email == admin) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LeadsUpdatePageADM(
                  lead: lead,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LeadsUpdatePageRegular(
                  lead: lead,
                )),
      );
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSnapshot(String query) {
    return FirebaseFirestore.instance
        .collection('leads')
        .where('situacao', isEqualTo: query)
        .get();
  }

  AppBar leadsAppBar(user) {
    if (user.email == master || user.email == admin) {
      return AppBar(
          title: Text('Leads'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  adicionarLead(user);
                },
                icon: Icon(Icons.add)),
          ],
          bottom: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: List<Widget>.generate(situacoes.length, (int index) {
                //return SizedBox(                   height: 25, child: new Text(situacoes[index].toString()));
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(situacoes[index].toString()),
                );
              })));
    } else {
      return AppBar(
          title: Text('Leads'),
          centerTitle: true,
          bottom: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: List<Widget>.generate(situacoes.length, (int index) {
                //return SizedBox(                    height: 25, child: new Text(situacoes[index].toString()));
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(situacoes[index].toString()),
                );
              })));
    }
  }

  setCurrentPage(page) {
    setState(() {
      pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance.collection('leads').snapshots();
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    //String currentName = user!.displayName.toString();
    //String uid = user.uid.toString();
    //String email = user.email.toString();
    //Corretor currentCorretor = new Corretor(nome: uid, email: email, uid: uid);

    return Scaffold(
      drawer: UserDrawer(),
      appBar: leadsAppBar(user),
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
                      List<Widget>.generate(situacoes.length, (int index) {
                    return ListView.builder(
                        //separatorBuilder: (context, i) => SizedBox(height: 0.0),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var leadInfo = snapshot.data!.docs[i];
                          String docID = snapshot.data!.docs[i].id;

                          Lead lead = Lead(
                              codCliente: leadInfo['codCliente'],
                              nome: leadInfo['nome'],
                              telefone: leadInfo['telefone'],
                              email: leadInfo['email'],
                              situacao: leadInfo['situacao'],
                              emailCorretor: leadInfo['emailCorretor'],
                              detalhes: leadInfo['detalhes'],
                              docId: docID);

                          if (leadInfo['situacao'] == situacoes[index]) {
                            //print('user: ${user.uid}');
                            //print('uid: ${leadInfo['uid']}');
                            if (leadInfo['emailCorretor'] == user!.email ||
                                user.email == master ||
                                user.email == admin) {
                              return ListTile(
                                  title: Text(leadInfo['nome']),
                                  subtitle: Text(
                                      'Telefone: ${leadInfo['telefone']}\nEmail: ${leadInfo['email']}\nObservação: ${leadInfo['detalhes']}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      editarLead(lead, user);
                                    },
                                  ));
                            }
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

class DesktopLeadsPage extends StatefulWidget {
  const DesktopLeadsPage({Key? key}) : super(key: key);

  @override
  _DesktopLeadsPageState createState() => _DesktopLeadsPageState();
}

class _DesktopLeadsPageState extends State<DesktopLeadsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<String> situacoes = [
    'Sem Acionamento',
    'Retornar mais tarde',
    //'Qualificado',
    'Interesse em Venda',
    'Interesse em Compra',
    'Captação',
    'Em negociação',
    'Fechado',
    'Sem interesse',
    'Não atende',
    'Telefone inexistente',
    'Outros',
  ].toList();

  @override
  void initState() {
    _tabController = TabController(length: situacoes.length, vsync: this);
    super.initState();
  }

  adicionarLead(user) {
    if (user.email == master || user.email == admin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LeadsAddPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LeadsAddPage()),
      );
    }
  }

  Future<void> editarLead(Lead lead, user) async {
    if (user.email == master || user.email == admin) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LeadsUpdatePageADM(
                  lead: lead,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LeadsUpdatePageRegular(
                  lead: lead,
                )),
      );
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSnapshot(String query) {
    return FirebaseFirestore.instance
        .collection('leads')
        .where('situacao', isEqualTo: query)
        .get();
  }

  AppBar leadsAppBar(user) {
    //if (user.email == master || user.email == admin) {
    return AppBar(
        title: Text('Leads'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                adicionarLead(user);
              },
              icon: Icon(Icons.add)),
        ],
        bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: List<Widget>.generate(situacoes.length, (int index) {
              //return SizedBox(                   height: 25, child: new Text(situacoes[index].toString()));
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(situacoes[index].toString()),
              );
            })));
    /*} else {
      return AppBar(
          title: Text('Leads'),
          centerTitle: true,
          bottom: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: List<Widget>.generate(situacoes.length, (int index) {
                //return SizedBox(                    height: 25, child: new Text(situacoes[index].toString()));
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(situacoes[index].toString()),
                );
              })));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance.collection('leads').snapshots();
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    //String currentName = user!.displayName.toString();
    //String uid = user.uid.toString();
    //String email = user.email.toString();
    //Corretor currentCorretor = new Corretor(nome: uid, email: email, uid: uid);

    return Scaffold(
      drawer: UserDrawer(),
      appBar: leadsAppBar(user),
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
                      List<Widget>.generate(situacoes.length, (int index) {
                    return ListView.builder(
                        //separatorBuilder: (context, i) => SizedBox(height: 0.0),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var leadInfo = snapshot.data!.docs[i];
                          String docID = snapshot.data!.docs[i].id;

                          Lead lead = Lead(
                              codCliente: leadInfo['codCliente'],
                              nome: leadInfo['nome'],
                              telefone: leadInfo['telefone'],
                              email: leadInfo['email'],
                              situacao: leadInfo['situacao'],
                              emailCorretor: leadInfo['emailCorretor'],
                              detalhes: leadInfo['detalhes'],
                              docId: docID);

                          if (leadInfo['situacao'] == situacoes[index]) {
                            //print('user: ${user.uid}');
                            //print('uid: ${leadInfo['uid']}');
                            if (leadInfo['emailCorretor'] == user!.email ||
                                user.email == master ||
                                user.email == admin) {
                              return ListTile(
                                  title: Text(
                                      "${leadInfo['codCliente']} - ${leadInfo['nome']}"),
                                  subtitle: Text(
                                      'Telefone: ${leadInfo['telefone']}\nEmail: ${leadInfo['email']}\nObservação: ${leadInfo['detalhes']}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      editarLead(lead, user);
                                    },
                                  ));
                            }
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

/*
Scaffold(
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
                      List<Widget>.generate(situacoes.length, (int index) {
                    return ListView.builder(
                        //separatorBuilder: (context, i) => SizedBox(height: 0.0),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var leadInfo = snapshot.data!.docs[i];
                          String docID = snapshot.data!.docs[i].id;

                          Lead lead = Lead(
                              nome: leadInfo['nome'],
                              telefone: leadInfo['telefone'],
                              email: leadInfo['email'],
                              situacao: leadInfo['situacao'],
                              emailCorretor: leadInfo['emailCorretor'],
                              detalhes: leadInfo['detalhes'],
                              docId: docID);

                          if (leadInfo['situacao'] == situacoes[index]) {
                            //print('user: ${user.uid}');
                            //print('uid: ${leadInfo['uid']}');
                            if (leadInfo['emailCorretor'] == user.email ||
                                user.email == master ||
                                user.email == admin) {
                              return ListTile(
                                  title: Text(leadInfo['nome']),
                                  subtitle: Text(
                                      'Telefone: ${leadInfo['telefone']}\nEmail: ${leadInfo['email']}\nObservação: ${leadInfo['detalhes']}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      editarLead(lead, user);
                                    },
                                  ));
                            }
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
    );*/