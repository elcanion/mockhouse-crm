import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockhouse_crm/pages/user_drawer.dart';
import 'package:mockhouse_crm/services/auth_service.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String currentName = user!.displayName.toString();
    String currentEmail = user.email.toString();

    return Scaffold(
      drawer: UserDrawer(),
      appBar: AppBar(
        title: Text('Usuário'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(currentName),
            subtitle: Text(currentEmail),
          ),
        ],
      ),
    );
  }
}
