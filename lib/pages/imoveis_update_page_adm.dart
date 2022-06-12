import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockhouse_crm/models/imovel.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ImoveisUpdatePage extends StatefulWidget {
  static String? nome;
  final Imovel imovel;

  const ImoveisUpdatePage({Key? key, required this.imovel}) : super(key: key);

  @override
  _ImoveisUpdatePageState createState() => _ImoveisUpdatePageState();
}

class _ImoveisUpdatePageState extends State<ImoveisUpdatePage> {
  String? selecao;
  String? selecaoTipo;
  bool? habitse;
  bool? escritura;
  bool? exclusividade;
  bool? parceiros;

  @override
  initState() {
    selecao = widget.imovel.situacao;
    selecaoTipo = widget.imovel.tipoImovel;
    if (widget.imovel.habitse == null) {
      habitse = false;
    } else if (widget.imovel.escritura == null) {
      escritura = false;
    } else if (widget.imovel.exclusividade == null) {
      exclusividade = false;
    } else if (widget.imovel.parceiros == null) {
      parceiros = false;
    } else {
      habitse = widget.imovel.habitse;
      escritura = widget.imovel.escritura;
      exclusividade = widget.imovel.exclusividade;
      parceiros = widget.imovel.parceiros;
    }
    print(widget.imovel.tipoImovel);
    super.initState();
  }

  CollectionReference imoveis =
      FirebaseFirestore.instance.collection('imoveis');

  Future<void> update() {
    return imoveis
        .doc(widget.imovel.docId)
        .update({
          'endereco': widget.imovel.endereco,
          'proprietario': widget.imovel.proprietario,
          'telefone': widget.imovel.telefone,
          'email': widget.imovel.email,
          'valor': widget.imovel.valor,
          'tamanho': widget.imovel.tamanho,
          'areaUtil': widget.imovel.areaUtil,
          'quartos': widget.imovel.quartos,
          'banheiros': widget.imovel.banheiros,
          'nMatricula': widget.imovel.nMatricula,
          'observacao': widget.imovel.observacao,
          'agenda': widget.imovel.agenda,
          'agendaDefinida': widget.imovel.agendaDefinida,
          'corretorResponsavel': widget.imovel.corretorResponsavel,
          'situacao': widget.imovel.situacao,
          'tipoImovel': widget.imovel.tipoImovel,
          'habitse': habitse,
          'escritura': escritura,
          'exclusividade': exclusividade,
          'parceiros': parceiros,
        })
        .then((value) => print("Atualizado"))
        .catchError((error) => print("Atualização falhou: $error"));
  }

  Future<void> delete() {
    if (widget.imovel.imagemDefinida == true) {
      FirebaseStorage.instance.refFromURL(widget.imovel.imagemUrl).delete();
    }

    return imoveis
        .doc(widget.imovel.docId)
        .delete()
        .then((value) => print("Imóvel deletado"))
        .catchError((error) => print("Exclusão falhou"));
  }

  final List<String> situacoes = [
    'Disponível',
    'Em processo de compra',
    'Fechados',
    //'Nossos imóveis',
    //'Parceiros',
  ].toList();
  //String selecao = 'Nossos imóveis';

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
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    final endereco = TextEditingController(text: widget.imovel.endereco);
    final proprietario =
        TextEditingController(text: widget.imovel.proprietario);
    final telefone = TextEditingController(text: widget.imovel.telefone);
    final email = TextEditingController(text: widget.imovel.email);
    final valor = TextEditingController(text: widget.imovel.valor);
    final tamanho = TextEditingController(text: widget.imovel.tamanho);
    final areaUtil = TextEditingController(text: widget.imovel.areaUtil);
    final quartos = TextEditingController(text: widget.imovel.quartos);
    final banheiros = TextEditingController(text: widget.imovel.banheiros);
    final nMatricula = TextEditingController(text: widget.imovel.nMatricula);
    final observacao = TextEditingController(text: widget.imovel.observacao);

    final dropdownOpcoes = situacoes
        .map((String item) =>
            new DropdownMenuItem(value: item, child: new Text(item)))
        .toList();

    final dropdownTipos = tipoImovel
        .map((String item) =>
            new DropdownMenuItem(value: item, child: new Text(item)))
        .toList();

    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('imoveis')
            .doc(widget.imovel.docId)
            .snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Editar imóvel'),
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
                              value = 'Campo obrigatório';
                            }
                            return null;
                          },
                          controller: proprietario,
                          decoration:
                              InputDecoration(labelText: 'Proprietário'),
                        ),
                        Row(children: [
                          Flexible(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  value = 'Campo obrigatório';
                                }
                                return null;
                              },
                              controller: telefone,
                              decoration:
                                  InputDecoration(labelText: 'Telefone'),
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
                        Row(children: [
                          Flexible(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  value = '';
                                }
                                print(value);
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
                                  value = '';
                                }
                                return null;
                              },
                              controller: areaUtil,
                              decoration:
                                  InputDecoration(labelText: 'Área Útil'),
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
                              decoration:
                                  InputDecoration(labelText: 'Banheiros'),
                            ),
                          ),
                        ]),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: habitse,
                              onChanged: (bool? value) {
                                setState(() {
                                  habitse = value!;
                                  print(habitse);
                                });
                              },
                            ),
                            Text('Habit-se'),
                            Checkbox(
                              value: escritura,
                              onChanged: (bool? value) {
                                setState(() {
                                  escritura = value!;
                                  print(escritura);
                                });
                              },
                            ),
                            Text('Escritura'),
                            Checkbox(
                                value: exclusividade,
                                onChanged: (bool? value) {
                                  setState(() {
                                    exclusividade = value!;
                                  });
                                }),
                            Text('Exclusividade'),
                            Checkbox(
                                value: parceiros,
                                onChanged: (bool? value) {
                                  setState(() {
                                    parceiros = value!;
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
                              widget.imovel.situacao = selecao;
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
                              widget.imovel.tipoImovel = selecaoTipo;
                              print(novoTipo);
                              print(selecaoTipo);
                            });
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              if (_form.currentState!.validate()) {
                                setState(() {
                                  widget.imovel.endereco = endereco.text;
                                  widget.imovel.proprietario =
                                      proprietario.text;
                                  widget.imovel.telefone = telefone.text;
                                  widget.imovel.email = email.text;
                                  widget.imovel.valor = valor.text;
                                  widget.imovel.tamanho = tamanho.text;
                                  widget.imovel.areaUtil = areaUtil.text;
                                  widget.imovel.quartos = quartos.text;
                                  widget.imovel.banheiros = banheiros.text;
                                  widget.imovel.nMatricula = nMatricula.text;
                                  widget.imovel.observacao = observacao.text;
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
                            child: Text('Excluir imóvel')),
                      ],
                    ),
                  ),
                ),
              )));
        });
  }
}
