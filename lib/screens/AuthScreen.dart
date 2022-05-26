import 'package:flutter/material.dart';

import '../widgets/AuthForm.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
              'CONVERSE',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
                //backgroundColor: Colors.pink,
                decoration: TextDecoration.overline,
              ),
            ),
          ),
          AuthForm(),
        ],
      ),
    );
  }
}
