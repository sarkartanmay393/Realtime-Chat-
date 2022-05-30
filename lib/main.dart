import 'package:firebase_auth/firebase_auth.dart';
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
        // useMaterial3: true,
        primarySwatch: Colors.pink,
        backgroundColor: Colors.grey.shade500,
        canvasColor: Color.fromARGB(255, 248, 249, 249),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, ss) {
          if (ss.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        ChatScreen.routeName: (context) => ChatScreen(),
        AuthScreen.routeName: (context) => AuthScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
