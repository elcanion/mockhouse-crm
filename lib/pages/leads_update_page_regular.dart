import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockhouse_crm/models/lead.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class LeadsUpdatePageRegular extends StatefulWidget {
  final Lead lead;

  const LeadsUpdatePageRegular({Key? key, required this.lead})
      : super(key: key);

  @override
  _LeadsUpdatePageRegularState createState() => _LeadsUpdatePageRegularState();
}

class _LeadsUpdatePageRegularState extends State<LeadsUpdatePageRegular> {
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

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nome: ${widget.lead.nome}',
                          ),
                          Text('Telefone: ${widget.lead.telefone}'),
                          Text('Email: ${widget.lead.email}'),
                        ],
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
                            widget.lead.detalhes = detalhesController.text;
                            widget.lead.situacao = selecao!;
                          });
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              setState(() {
                                widget.lead.detalhes = detalhesController.text;
                              });
                              update();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Atualizar')),
                    ],
                  ),
                ),
              )));
        });
  }
}
