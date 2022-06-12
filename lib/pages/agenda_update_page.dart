import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockhouse_crm/models/meeting.dart';
import 'package:intl/intl.dart';

class AgendaUpdatePage extends StatefulWidget {
  static String? nome;
  final Meeting appointment;

  const AgendaUpdatePage({Key? key, required this.appointment})
      : super(key: key);

  @override
  _AgendaUpdatePageState createState() => _AgendaUpdatePageState();
}

class _AgendaUpdatePageState extends State<AgendaUpdatePage> {
  Meeting? appointment;
  String? subject;
  String? docId;
  late DateTime from;
  late DateTime to;
  String? adicionadoPor = '';
  String? emailVinculado = '';
  String formattedDateFrom = '';
  String formattedDateTo = '';

  late bool agendaDefinidaTeste = false;
  late DateTime fromData = DateTime.now();
  late TimeOfDay fromHora = TimeOfDay.now();
  //late DateTime toData = DateTime.now();
  //late TimeOfDay toHora = TimeOfDay.now();
  late DateTime formatFrom = from;
  late DateTime formatTo = to;

  initState() {
    appointment = widget.appointment;
    subject = widget.appointment.eventName;
    from = widget.appointment.from!;
    to = widget.appointment.to!;
    docId = widget.appointment.docId;
    adicionadoPor = widget.appointment.adicionadoPor;
    emailVinculado = widget.appointment.emailVinculado;

    super.initState();
  }

  final data = DateTime.now();

  _definirFromAgenda() async {
    final data = await showDatePicker(
      context: context,
      initialDate: widget.appointment.from!,
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
      initialDate: widget.appointment.to!,
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

  CollectionReference agenda = FirebaseFirestore.instance.collection('agenda');

  Future<void> delete() {
    return agenda
        .doc(docId)
        .delete()
        .then((value) => print("Visita deletada"))
        .catchError((error) => print("Exclusão falhou"));
  }

  Future<void> deletetwo() {
    return FirebaseFirestore.instance.collection('agenda').doc(docId).delete();
  }

  Future<void> update() {
    return FirebaseFirestore.instance.collection('agenda').doc(docId).update({
      'nomeEvento': subject,
      'dataInicio': DateFormat('dd/MM/yyyy - kk:mm').format(formatFrom),
      'dataFim': DateFormat('dd/MM/yyyy - kk:mm').format(formatTo),
    });
  }

  @override
  Widget build(BuildContext context) {
    print(docId);
    final _form = GlobalKey<FormState>();
    final nomeEvento = TextEditingController(text: subject.toString());

    String formattedDateTo = DateFormat('dd/MM/yyyy - kk:mm').format(formatTo);

    String formattedDateFrom =
        DateFormat('dd/MM/yyyy - kk:mm').format(formatFrom);

    return Scaffold(
        appBar: AppBar(
          title: Text('Atualizar visita'),
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
                  controller: nomeEvento,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _definirFromAgenda();
                      },
                      child: Text('De: $formattedDateFrom'),
                    ),
                    TextButton(
                      onPressed: () {
                        _definirToAgenda();
                      },
                      child: Text('Até: $formattedDateTo'),
                    ),
                  ],
                ),
                Text('Adicionado por: $adicionadoPor'),
                TextButton(
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        setState(() {
                          subject = nomeEvento.text;
                          from = formatFrom;
                          to = formatTo;
                        });
                        update();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Concluir')),
                TextButton(
                  onPressed: () {
                    deletetwo();
                    Navigator.of(context).pop();
                  },
                  child: Text('Desmarcar visita'),
                )
              ],
            ),
          ),
        )));
  }
}
