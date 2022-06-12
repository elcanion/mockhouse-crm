import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mockhouse_crm/models/imovel.dart';
import 'package:mockhouse_crm/pages/imoveis_update_page_adm.dart';
import 'package:intl/intl.dart';

/* Devo alterar esse import para universal_html em versões futuras */
import 'dart:html' as h;

String master = 'sibmobsi@gmail.com';
String admin = 'gabrielhts1@gmail.com';

class ImovelCardTwo extends StatefulWidget {
  final Imovel imovel;

  const ImovelCardTwo({
    required this.imovel,
  });

  @override
  _ImovelCardTwoState createState() => _ImovelCardTwoState();
}

class _ImovelCardTwoState extends State<ImovelCardTwo> {
  CollectionReference imoveis =
      FirebaseFirestore.instance.collection('imoveis');
  late Imovel imovel;
  //late File image;
  late String imagemUrl;
  late bool imagemDefinida = imovel.imagemDefinida;
  late bool agendaDefinidaTeste = false;
  late DateTime agendaData = DateTime.now();
  late TimeOfDay agendaHora = TimeOfDay.now();
  late DateTime agenda = widget.imovel.agenda;

  initState() {
    imovel = widget.imovel;
    super.initState();
  }

  _editarImovel(Imovel imovel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ImoveisUpdatePage(imovel: imovel),
            settings: RouteSettings(arguments: imovel)));
  }

  showImage() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (imovel.imagemDefinida == true) {
      return IconButton(
        onPressed: () {
          if (user!.email == admin || user.email == master) {
            uploadToStorage();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Função disponível apenas para o administrador'),
            ));
          }
        },
        icon: Image.network(imovel.imagemUrl, fit: BoxFit.fitWidth),
        iconSize: 300,
      );
    } else {
      return TextButton(
          onPressed: () {
            if (user!.email == admin || user.email == master) {
              uploadToStorage();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Função disponível apenas para o administrador'),
              ));
            }
          },
          child: Text('Definir imagem'));
    }
  }

  void uploadImageWeb({required Function(h.File file) onSelected}) {
    h.InputElement uploadInput = h.FileUploadInputElement() as h.InputElement
      ..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = h.FileReader();
      reader.readAsDataUrl(file);
      reader.onError.listen((event) {
        CircularProgressIndicator();
      });
      reader.onLoad.listen((event) {
        //return print('Carregando');
        CircularProgressIndicator();
      });
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  void uploadToStorage() async {
    if (imovel.imagemDefinida == true) {
      FirebaseStorage.instance.refFromURL(imovel.imagemUrl).delete();
    }
    String imagemNome =
        'imovel' + DateTime.now().millisecondsSinceEpoch.toString();
    uploadImageWeb(onSelected: (file) async {
      final storage = FirebaseStorage.instance;
      var snapshot = await storage.ref().child(imagemNome).putBlob(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      FirebaseStorage.instance
          .refFromURL('gs://sibmob-62b2e.appspot.com')
          .child(imagemNome)
          .putBlob(file);
      CollectionReference imoveis =
          FirebaseFirestore.instance.collection('imoveis');

      await imoveis
          .doc(imovel.docId)
          .update({
            'imagemDefinida': true,
            'imagemUrl': downloadUrl,
            'imagemNome': imagemNome,
          })
          .then((value) => print("Subiu imagem"))
          .catchError((error) => print("Atualização falhou: $error"));

      setState(() {
        imovel.imagemNome = imagemNome;
        imovel.imagemUrl = downloadUrl;
        imovel.imagemDefinida = true;
      });
    });
  }

  Future<String> downloadUrl(Imovel imovel) async {
    return FirebaseStorage.instance
        .refFromURL('gs://sibmob-62b2e.appspot.com')
        .child(imovel.imagemNome)
        .getDownloadURL();
  }

  /*Future<void> updateImage(FirebaseStorage storage, File image) async {
    FirebaseStorage.instance.refFromURL(imovel.imagemUrl).delete();

    var snapshot = await storage.ref().child(imovel.imagemNome).putFile(image);

    var downloadUrl = await snapshot.ref.getDownloadURL();
    CollectionReference imoveis =
        FirebaseFirestore.instance.collection('imoveis');

    imoveis
        .doc(imovel.docId)
        .update({
          'imagemDefinida': true,
          'imagemUrl': downloadUrl,
        })
        .then((value) => print("Atualizado"))
        .catchError((error) => print("Atualização falhou: $error"));

    setState(() {
      imovel.imagemUrl = downloadUrl;
      imovel.imagemDefinida = true;
    });
  }

  Future<void> _chooseImage() async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    imagemDefinida = imovel.imagemDefinida;

    if (imagemDefinida == false && pickedFile != null) {
      uploadImage(storage, File(pickedFile.path));
    } else if (imagemDefinida == true && pickedFile != null) {
      updateImage(storage, File(pickedFile.path));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Você não selecionou nenhuma imagem')));
    }
  }*/

  Widget getHabitSe() {
    if (widget.imovel.habitse == true)
      return Text('Habit-se: sim');
    else
      return Text('Habit-se: não');
  }

  Widget getEscritura() {
    if (widget.imovel.escritura == true)
      return Text('Escritura: sim');
    else
      return Text('Escritura: não');
  }

  Widget getExclusividade() {
    if (widget.imovel.exclusividade == true)
      return Text(' - Exclusividade: sim');
    else
      return Text('');
  }

  String getParceiros() {
    if (widget.imovel.parceiros == true)
      return ' - Parceiros: sim';
    else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    return Card(
        elevation: 2.0,
        child: Container(
          width: 350,
          child: ExpansionTile(
            title: _buildTitle(user),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hotel),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Text("Quartos: ${widget.imovel.quartos}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.open_with),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Text("Tamanho: ${widget.imovel.tamanho}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.description),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          getHabitSe(),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bathtub),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Text("Banheiros: ${widget.imovel.banheiros}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.open_with),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Text("Área útil: ${widget.imovel.areaUtil}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.description),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          getEscritura(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              showImage(),
            ],
          ),
        ));
  }

  Widget observacaoScaffold(BuildContext context) {
    final _form = GlobalKey<FormState>();
    final observacaoController = TextEditingController(text: imovel.observacao);

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar observação'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _form,
              child: Column(children: [
                TextFormField(
                  controller: observacaoController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextButton(
                    child: Text('Adicionar'),
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        setState(() {
                          imovel.observacao = observacaoController.text;
                        });
                        setObservacao();

                        Navigator.of(context).pop();
                      }
                    }),
              ]))),
    );
  }

  Future<void> setObservacao() {
    CollectionReference imoveis =
        FirebaseFirestore.instance.collection('imoveis');
    return imoveis
        .doc(widget.imovel.docId)
        .update({
          'observacao': imovel.observacao,
        })
        .then((value) => print("Atualizado"))
        .catchError((error) => print("Atualização falhou: $error"));
  }

  Widget getObservacao() {
    if (imovel.observacao == null || imovel.observacao == '')
      return Text('Nenhuma observação definida');
    return Text('${imovel.observacao}');
  }

  Widget _agendaTile() {
    String formattedDate = DateFormat('dd/MM/yyyy - kk:mm').format(agenda);
    if (imovel.agendaDefinida == true)
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        title: Text(
          'Disponível em: $formattedDate',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        trailing: IconButton(
            onPressed: () {
              _definirAgenda();
            },
            icon: Icon(Icons.edit)),
      );
    else
      return TextButton(
          onPressed: () {
            _definirAgenda();
          },
          child: Text('Definir horário disponível'));
  }

  _definirAgenda() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
      locale: Locale("pt", "BR"),
    );
    final hora =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    setState(() {
      agendaData = data!;
      agendaHora = hora!;
      agenda = new DateTime(agendaData.year, agendaData.month, agendaData.day,
          agendaHora.hour, agendaHora.minute);
      imovel.agendaDefinida = true;
    });
    CollectionReference imoveis =
        FirebaseFirestore.instance.collection('imoveis');
    return imoveis
        .doc(widget.imovel.docId)
        .update({
          'agenda': Timestamp.fromDate(agenda),
          'agendaDefinida': true,
        })
        .then((value) => print("Atualizado"))
        .catchError((error) => print("Atualização falhou: $error"));
  }

  String buildObservacao() {
    if (widget.imovel.observacao != null || widget.imovel.observacao != '') {
      return 'Observação: ${widget.imovel.observacao}';
    } else
      return 'Nenhuma observação';
  }

  String buildExclusividade() {
    if (widget.imovel.exclusividade != null ||
        widget.imovel.exclusividade != false) {
      return '\nExclusividade: Sim';
    } else
      return '';
  }

  Widget _buildTitle(user) {
    if (user.email == master || user.email == admin) {
      return Column(children: [
        ListTile(
          title: Text(
              '${widget.imovel.nMatricula} - ${widget.imovel.endereco}${getParceiros()}'),
          subtitle: Text(
              'Proprietário: ${widget.imovel.proprietario}\nValor: ${widget.imovel.valor}\nCorretor responsável: ${widget.imovel.corretorResponsavel}\n${buildObservacao()}${buildExclusividade()}'),
        ),
        _agendaTile(),
        Center(
            child: TextButton(
                onPressed: () {
                  _editarImovel(widget.imovel);
                },
                child: Text('Editar imóvel'))),
      ]);
    } else {
      return Column(children: [
        ListTile(
          title: Text(
              '${widget.imovel.nMatricula} - ${widget.imovel.endereco}${getParceiros()}'),
          subtitle: Text(
              'Proprietário: ${widget.imovel.proprietario}\nValor: ${widget.imovel.valor}\nCorretor responsável: ${widget.imovel.corretorResponsavel}'),
        ),
        _agendaTile(),
      ]);
    }
  }
}
