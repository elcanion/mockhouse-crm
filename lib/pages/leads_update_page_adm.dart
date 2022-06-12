import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockhouse_crm/models/corretor.dart';
import 'package:mockhouse_crm/models/lead.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class LeadsUpdatePageADM extends StatefulWidget {
  final Lead lead;

  const LeadsUpdatePageADM({Key? key, required this.lead}) : super(key: key);

  @override
  _LeadsUpdatePageADMState createState() => _LeadsUpdatePageADMState();
}

class _LeadsUpdatePageADMState extends State<LeadsUpdatePageADM> {
  String? codCliente;
  String? docId;
  String? nome;
  String? telefone;
  String? email;
  String? detalhes;
  String? selecao;

  @override
  initState() {
    codCliente = widget.lead.codCliente;
    nome = widget.lead.nome;
    telefone = widget.lead.telefone;
    email = widget.lead.email;
    selecao = widget.lead.situacao;
    docId = widget.lead.docId;
    super.initState();
  }

  CollectionReference leads = FirebaseFirestore.instance.collection('leads');

  Future<void> update() {
    return leads
        .doc(docId)
        .update({
          'codCliente': widget.lead.codCliente,
          'nome': widget.lead.nome,
          'telefone': widget.lead.telefone,
          'email': widget.lead.email,
          'detalhes': widget.lead.detalhes,
          'situacao': widget.lead.situacao
        })
        .then((value) => print("Atualizado"))
        .catchError((error) => print("Atualização falhou: $error"));
  }

  Future<void> delete() {
    return leads
        .doc(docId)
        .delete()
        .then((value) => print("Lead deletado"))
        .catchError((error) => print("Exclusão falhou"));
  }

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
    'Outros'
  ].toList();
  final List<Corretor> corretores = [];
  //String selecao = 'Sem acionamento';

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    final codClienteController =
        TextEditingController(text: widget.lead.codCliente);
    final nomeController = TextEditingController(text: widget.lead.nome);
    final telefoneController =
        TextEditingController(text: widget.lead.telefone);
    final emailController = TextEditingController(text: widget.lead.email);
    final emailCorretorController =
        TextEditingController(text: widget.lead.emailCorretor);
    final detalhesController =
        TextEditingController(text: widget.lead.detalhes);
    final dropdownOpcoes = situacoes
        .map((String item) =>
            new DropdownMenuItem(value: item, child: new Text(item)))
        .toList();

    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('leads')
            .doc(widget.lead.docId)
            .snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Editar lead'),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                  child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: codClienteController,
                        decoration: InputDecoration(labelText: 'Cód. Cliente'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: nomeController,
                        decoration: InputDecoration(labelText: 'Nome'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: telefoneController,
                        decoration: InputDecoration(labelText: 'Telefone'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            value = '';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Este campo deve ser preenchido';
                          }
                          return null;
                        },
                        controller: emailCorretorController,
                        decoration:
                            InputDecoration(labelText: 'Email do corretor'),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('corretores')
                            .snapshots(),
                        builder:
                            (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                          if (usersnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: usersnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var corretorInfo =
                                    usersnapshot.data!.docs[index];
                                Corretor corretor = Corretor(
                                    nome: corretorInfo['nome'],
                                    email: corretorInfo['email'],
                                    uid: corretorInfo['uid']);
                                corretores.add(corretor);

                                return Text(
                                    '${corretores[index].nome} email: ${corretores[index].email}');
                              },
                            );
                          }
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            value = '';
                          }
                          return null;
                        },
                        controller: detalhesController,
                        decoration: InputDecoration(labelText: 'Detalhes'),
                      ),
                      DropdownButton(
                        hint: Text('Situação'),
                        value: selecao,
                        items: dropdownOpcoes,
                        onChanged: (String? novaSituacao) {
                          setState(() {
                            selecao = novaSituacao!;
                            //widget.lead.nome = nomeController.text;
                            //widget.lead.telefone = telefoneController.text;
                            //widget.lead.email = emailController.text;
                            widget.lead.detalhes = detalhesController.text;
                            widget.lead.situacao = selecao!;
                          });
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              setState(() {
                                //widget.lead.nome = nomeController.text;
                                //widget.lead.telefone = telefoneController.text;
                                //widget.lead.email = emailController.text;
                                widget.lead.detalhes = detalhesController.text;
                              });
                              update();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Atualizar')),
                      TextButton(
                          onPressed: () {
                            delete();
                            Navigator.of(context).pop();
                          },
                          child: Text('Excluir lead')),
                    ],
                  ),
                ),
              )));
        });
  }
}
