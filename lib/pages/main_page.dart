import 'package:csv/csv.dart';
import 'package:mockhouse_crm/pages/agenda_page.dart';
import 'package:mockhouse_crm/pages/imoveis_filtro_page.dart';
import 'package:mockhouse_crm/pages/imoveis_page.dart';
import 'package:mockhouse_crm/pages/leads_page.dart';
import 'package:mockhouse_crm/pages/proprietarios_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int pageIndex = 0;
late PageController pageController;

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return DesktopMainPage();
      } else {
        return MobileMainPage();
      }
    });
  }
}

class MobileMainPage extends StatefulWidget {
  const MobileMainPage({Key? key}) : super(key: key);

  @override
  _MobileMainPageState createState() => _MobileMainPageState();
}

class _MobileMainPageState extends State<MobileMainPage> {
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
  }

  setCurrentPage(page) {
    setState(() {
      pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            LeadsPage(),
            ImoveisPage(),
            ImoveisFiltroPage(),
            ProprietariosPage(),
            AgendaPage(),
          ],
          onPageChanged: setCurrentPage,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Leads'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Imóveis'),
            BottomNavigationBarItem(
                icon: Icon(Icons.view_list), label: 'Tipo de imóveis (filtro)'),
            BottomNavigationBarItem(
                icon: Icon(Icons.thumb_up), label: 'Proprietários'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Agenda'),
          ],
          onTap: (page) {
            pageController.animateToPage(page,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
        ));
  }
}

class DesktopMainPage extends StatefulWidget {
  const DesktopMainPage({Key? key}) : super(key: key);

  @override
  _DesktopMainPageState createState() => _DesktopMainPageState();
}

class _DesktopMainPageState extends State<DesktopMainPage> {
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
  }

  setCurrentPage(page) {
    setState(() {
      pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold(body: ImoveisPage());
    return MobileMainPage();
  }
}

class DesktopMenu extends StatefulWidget {
  const DesktopMenu({Key? key}) : super(key: key);

  @override
  _DesktopMenuState createState() => _DesktopMenuState();
}

class _DesktopMenuState extends State<DesktopMenu> {
  toLeads() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LeadsPage()),
    );
  }

  toImoveis() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ImoveisPage()),
    );
  }

  toTipoImoveis() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ImoveisFiltroPage()),
    );
  }

  toProprietarios() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ProprietariosPage()),
    );
  }

  toAgenda() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AgendaPage()),
    );
  }

  /*loadExcel() async {
    ByteData data = await rootBundle.load("assets/test.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    int j = 0;
    Map<int, List> mp = Map<int, List>();
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        mp[++j] = row;
        //print(mp[j]);
      }
    }
    List list = List<String>.generate(excel.tables.length, (int index) {
      return 'teste';
    });
    print(list);
  }*/

  Future<void> loadcsv() async {
    /*File? file;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      print('cancelled');
    }*/
    final data = await rootBundle.loadString('test3.csv');
    //List table = CsvToListConverter().convert(data);
    //List listhehe = CsvToListConverter().convert(table.toString());
    List<List<dynamic>> csv = CsvToListConverter(
      //shouldParseNumbers: true,
      eol: "\n",
      fieldDelimiter: ',',
      //textDelimiter: "'",
    ).convert(data);
    //print(csv);
    print(csv);
    print(csv[0]);
    print(csv[1]);

    //CsvToListConverter().convert(data, eol: '\n', textDelimiter: ',');
    //print(table);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(child: Icon(Icons.account_circle)),
        Text('Nome'),
        ListTile(
          title: Text('Leads'),
          onTap: toLeads,
        ),
        ListTile(
          title: Text('Imóveis'),
          onTap: toImoveis,
        ),
        ListTile(
          title: Text('Tipos de Imóveis'),
          onTap: toTipoImoveis,
        ),
        ListTile(
          title: Text('Proprietários'),
          onTap: toProprietarios,
        ),
        ListTile(
          title: Text('Agenda'),
          onTap: toAgenda,
        ),
        ListTile(
          title: Text('Carregar excel'),
          onTap: loadcsv,
        )
      ],
    );
  }
}
