import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockhouse_crm/models/meeting.dart';
import 'package:mockhouse_crm/pages/agenda_add_page.dart';
import 'package:mockhouse_crm/pages/agenda_update_page.dart';
import 'package:mockhouse_crm/pages/user_drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:flutter/scheduler.dart';

List<Color> _colorCollection = <Color>[];
MeetingDataSource? eventos;
final databaseReference = FirebaseFirestore.instance;

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  AgendaPageState createState() => AgendaPageState();
}

class AgendaPageState extends State<AgendaPage> {
  String? idEvento;
  late Meeting appointment;

  @override
  void initState() {
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {});
    });
    super.initState();
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF3D4FB5));
  }

  Future<void> getDataFromFireStore() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    //String currentName = user!.displayName.toString();
    var snapShotsValue = await databaseReference
        .collection("agenda")
        .where('emailVinculado', isEqualTo: user!.email)
        .get();
    if (!mounted) return;

    final Random random = new Random();
    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
            eventName: e.data()['nomeEvento'],
            from:
                DateFormat('dd/MM/yyyy - HH:mm').parse(e.data()['dataInicio']),
            to: DateFormat('dd/MM/yyyy - HH:mm').parse(e.data()['dataFim']),
            docId: e.data()['idEvento'],
            background: _colorCollection[random.nextInt(1)],
            adicionadoPor: e.data()['adicionadoPor'],
            isAllDay: false))
        .toList();
    setState(() {
      eventos = MeetingDataSource(list);
    });
  }

  atualizarEvento(Meeting appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AgendaUpdatePage(
                appointment: appointment,
              )),
    );
  }

  adicionarEvento() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AgendaAddPage()),
    );
  }

  CalendarController _calendarController = CalendarController();

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Meeting appointment = calendarTapDetails.appointments![0];
      print(appointment.docId);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AgendaUpdatePage(appointment: appointment)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {});
    });
    return Scaffold(
      drawer: UserDrawer(),
      appBar: AppBar(
        title: Text('Agenda'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              adicionarEvento();
            },
          ),
        ],
      ),
      body: SfCalendar(
        view: CalendarView.month,
        showNavigationArrow: true,
        onTap: calendarTapped,
        controller: _calendarController,
        initialDisplayDate: DateTime.now(),
        maxDate: DateTime(2040, 12, 31, 0, 0, 0),
        dataSource: eventos,
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          agendaStyle: AgendaStyle(),
        ),
      ),
    );
  }
}
