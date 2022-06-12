import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ImoveisAddPage extends StatefulWidget {
  static String? nome;

  const ImoveisAddPage({Key? key}) : super(key: key);

  @override
  _ImoveisAddPageState createState() => _ImoveisAddPageState();
}

class _ImoveisAddPageState extends State<ImoveisAddPage> {
  final _form = GlobalKey<FormState>();
  final endereco = TextEditingController();
  final proprietario = TextEditingController();
  final telefone = TextEditingController();
  final email = TextEditingController();
  final valor = TextEditingController();
  final tamanho = TextEditingController();
  final areaUtil = TextEditingController();
  final quartos = TextEditingController();
  final banheiros = TextEditingController();
  final nMatricula = TextEditingController();
  final observacao = TextEditingController();
  bool isCheckedHabitse = false;
  bool isCheckedEscritura = false;
  bool isCheckedExclusividade = false;
  bool isCheckedParceiros = false;
  final List<String> situacoes = [
    'Disponível',
    'Em processo de compra',
    'Fechados',
    //'Nossos imóveis',
    //'Parceiros',
  ].toList();
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
  String selecao = 'Disponível';
  String selecaoTipo = 'Apartamento';

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String currentName = user!.displayName.toString();

    final dropdownOpcoes = situacoes
        .map((String item) =>
            new DropdownMenuItem(value: item, child: new Text(item)))
        .toList();

    final dropdownTipos = tipoImovel
        .map((String item) =>
            new DropdownMenuItem(value: item, child: new Text(item)))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Adicionar imóvel'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        value = '';
                      }
                      return null;
                    },
                    controller: nMatricula,
                    decoration: InputDecoration(labelText: 'Cód. Imóvel'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                    controller: endereco,
                    decoration: InputDecoration(labelText: 'Endereço'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                    controller: proprietario,
                    decoration: InputDecoration(labelText: 'Proprietário'),
                  ),
                  Row(children: [
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: telefone,
                        decoration: InputDecoration(labelText: 'Telefone'),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            value = '';
                          }
                          return null;
                        },
                        controller: email,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                    ),
                  ]),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        value = 'R\$ 0';
                      }
                      return null;
                    },
                    controller: valor,
                    decoration: InputDecoration(labelText: 'Valor'),
                  ),
                  Row(children: [
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            value = '0';
                          }
                          return null;
                        },
                        controller: tamanho,
                        decoration: InputDecoration(labelText: 'Tamanho'),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            value = '0';
                          }
                          return null;
                        },
                        controller: areaUtil,
                        decoration: InputDecoration(labelText: 'Área Útil'),
                      ),
                    ),
                  ]),
                  Row(children: [
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            value = '';
                          }
                          return null;
                        },
                        controller: quartos,
                        decoration: InputDecoration(labelText: 'Quartos'),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            value = '';
                          }
                          return null;
                        },
                        controller: banheiros,
                        decoration: InputDecoration(labelText: 'Banheiros'),
                      ),
                    ),
                  ]),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                    controller: observacao,
                    decoration: InputDecoration(labelText: 'Observação'),
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isCheckedHabitse,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedHabitse = value!;
                          });
                        },
                      ),
                      Text('Habit-se'),
                      Checkbox(
                        value: isCheckedEscritura,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedEscritura = value!;
                          });
                        },
                      ),
                      Text('Escritura'),
                      Checkbox(
                          value: isCheckedExclusividade,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedExclusividade = value!;
                            });
                          }),
                      Text('Exclusividade'),
                      Checkbox(
                          value: isCheckedParceiros,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedParceiros = value!;
                            });
                          }),
                      Text('Parceiros'),
                    ],
                  ),
                  DropdownButton(
                    hint: Text('Situação'),
                    value: selecao,
                    items: dropdownOpcoes,
                    onChanged: (String? novaSituacao) {
                      setState(() {
                        selecao = novaSituacao!;
                        print(novaSituacao);
                        print(selecao);
                      });
                    },
                  ),
                  DropdownButton(
                    hint: Text('Tipo de imóvel'),
                    value: selecaoTipo,
                    items: dropdownTipos,
                    onChanged: (String? novoTipo) {
                      setState(() {
                        selecaoTipo = novoTipo!;
                        print(novoTipo);
                        print(selecaoTipo);
                      });
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        if (_form.currentState!.validate()) {
                          FirebaseFirestore.instance.collection('imoveis').add({
                            'endereco': endereco.text,
                            'proprietario': proprietario.text,
                            'telefone': telefone.text,
                            'email': email.text,
                            'valor': valor.text,
                            'tamanho': tamanho.text,
                            'areaUtil': areaUtil.text,
                            'quartos': quartos.text,
                            'banheiros': banheiros.text,
                            'nMatricula': nMatricula.text,
                            'observacao': observacao.text,
                            'agenda': Timestamp.fromDate(DateTime.now()),
                            'agendaDefinida': false,
                            'imagemUrl': '',
                            'imagemNome': '',
                            'imagemDefinida': false,
                            'habitse': isCheckedHabitse,
                            'escritura': isCheckedEscritura,
                            'exclusividade': isCheckedExclusividade,
                            'parceiros': isCheckedParceiros,
                            'corretorResponsavel': currentName,
                            'situacao': selecao.toString(),
                            'tipoImovel': selecaoTipo.toString(),
                          });
                          print(currentName);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Adicionar')),
                ],
              ),
            ),
          ),
        )));
  }
}
