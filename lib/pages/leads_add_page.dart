import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockhouse_crm/models/corretor.dart';

class LeadsAddPage extends StatefulWidget {
  static String? nome;

  const LeadsAddPage({Key? key}) : super(key: key);

  @override
  _LeadsAddPageState createState() => _LeadsAddPageState();
}

class _LeadsAddPageState extends State<LeadsAddPage> {
  final _form = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final emailCorretorController = TextEditingController();
  final codClienteController = TextEditingController();
  final detalhesController = TextEditingController();
  final List<String> situacoes = [
    'Sem Acionamento',
    'Retornar mais tarde',
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
  List<Corretor> corretores = [];
  String selecao = 'Sem Acionamento';
  String corretorSelecao = '';

  Widget corretoresList() {
    final dropdownCorretores = corretores
        .map((Corretor item) =>
            new DropdownMenuItem(value: item, child: new Text(item.nome)))
        .toList();
    return DropdownButton(
      hint: Text('Corretores'),
      value: corretorSelecao,
      items: dropdownCorretores,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownOpcoes = situacoes
        .map((String item) =>
            new DropdownMenuItem(value: item, child: new Text(item)))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Adicionar lead'),
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
                      return 'Este campo deve ser preenchido';
                    }
                    return null;
                  },
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo deve ser preenchido';
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
                  decoration: InputDecoration(labelText: 'Email do corretor'),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('corretores')
                      .snapshots(),
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                    if (usersnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: usersnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var corretorInfo = usersnapshot.data!.docs[index];
                          Corretor corretor = Corretor(
                              nome: corretorInfo['nome'],
                              email: corretorInfo['email'],
                              uid: corretorInfo['uid']);
                          corretores.add(corretor);
                          corretorSelecao = corretores.first.nome;

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
                    });
                  },
                ),
                TextButton(
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        FirebaseFirestore.instance.collection('leads').add({
                          'codCliente': codClienteController.text,
                          'nome': nomeController.text,
                          'telefone': telefoneController.text,
                          'email': emailController.text,
                          'situacao': selecao.toString(),
                          'emailCorretor': emailCorretorController.text,
                          'detalhes': detalhesController.text,
                        });

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Adicionar')),
              ],
            ),
          ),
        )));
  }
}
