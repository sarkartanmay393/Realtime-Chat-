import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/AuthForm.dart';
import './ChatScreen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = 'AuthScreen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void submitForm({
    required String email,
    String? username,
    required String password,
    required bool isLogin,
    required BuildContext ctx,
  }) async {
    final _auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
      setState(() {
        AuthForm.isLoading = false;
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred.';
      if (err.message! != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          //duration: const Duration(milliseconds: 200),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
              '${error.toString().substring((error.toString().indexOf(']')) + 1, error.toString().length)}'),
          //duration: const Duration(milliseconds: 200),
        ),
      );
      print(error);
    }
    setState(() {
      AuthForm.isLoading = false;
    });
    // print(email + password + isLogin.toString() + username!);
  }

  // var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Padding(
          //   padding: EdgeInsets.all(14.0),
          //   child: Text(
          //     'CONVERSE',
          //     style: TextStyle(
          //       fontSize: 32,
          //       fontWeight: FontWeight.bold,
          //       color: Color.fromARGB(255, 255, 255, 255),
          //       //backgroundColor: Colors.pink,
          //       decoration: TextDecoration.overline,
          //     ),
          //   ),
          // ),
          AuthForm(submitForm),
        ],
      ),
    );
  }
}
