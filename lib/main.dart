import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/ChatScreen.dart';
import './screens/AuthScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converse',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.grey.shade500,
        canvasColor: Colors.teal.shade300,
      ),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
