import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockhouse_crm/models/meeting.dart';
import 'package:intl/intl.dart';

class AgendaAddPage extends StatefulWidget {
  static String? nome;

  const AgendaAddPage({Key? key}) : super(key: key);

  @override
  _AgendaAddPageState createState() => _AgendaAddPageState();
}

class _AgendaAddPageState extends State<AgendaAddPage> {
  Meeting? appointment;
  String? subject = '';
  String? id;
  DateTime? from;
  late DateTime formatFrom;
  late DateTime formatTo;
  String formattedDateFrom = '';
  String formattedDateTo = '';

  final databaseReference = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  final data = DateTime.now();

  adicionarEvento() async {
    String idEvento =
        databaseReference.collection('agenda').doc().id.toString();
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String currentName = user!.displayName.toString();
    String currentEmail = user.email.toString();
    await databaseReference.collection("agenda").doc(idEvento).set({
      'idEvento': idEvento,
      'nomeEvento': subject,
      'descricao': 'Visitação',
      'dataInicio': formattedDateFrom,
      'dataFim': formattedDateTo,
      'adicionadoPor': currentName,
      'emailVinculado': currentEmail
    });
    print(idEvento);
  }

  _definirFromAgenda() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
      locale: Locale("pt", "BR"),
    );
    final hora =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (data == null || hora == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data e horário obrigatórios')));
    } else {
      setState(() {
        formatFrom = new DateTime(
            data.year, data.month, data.day, hora.hour, hora.minute);
        formattedDateFrom = DateFormat('dd/MM/yyyy - kk:mm').format(formatFrom);
      });
    }
  }

  _definirToAgenda() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
      locale: Locale("pt", "BR"),
    );
    final hora =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (data == null || hora == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data e horário obrigatórios')));
    } else {
      setState(() {
        formatTo = new DateTime(
            data.year, data.month, data.day, hora.hour, hora.minute);
        formattedDateTo = DateFormat('dd/MM/yyyy - kk:mm').format(formatTo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(id);
    final _form = GlobalKey<FormState>();
    final nomeEvento = TextEditingController(text: subject);

    return Scaffold(
        appBar: AppBar(
          title: Text('Agendar visita'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                  controller: nomeEvento,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      subject = nomeEvento.text;
                    });
                    _definirFromAgenda();
                  },
                  child: Text('De: $formattedDateFrom'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      subject = nomeEvento.text;
                    });
                    _definirToAgenda();
                  },
                  child: Text('Até: $formattedDateTo'),
                ),
                TextButton(
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        setState(() {
                          subject = nomeEvento.text;
                        });
                        if (formattedDateFrom == '' || formattedDateTo == '')
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('As datas são obrigatórias')));
                        else {
                          adicionarEvento();

                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text('Concluir')),
              ]),
            ),
          ),
        ));
  }
}
