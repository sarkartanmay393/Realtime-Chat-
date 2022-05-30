import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    File? image,
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
      } else if (image != null) {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref =
            FirebaseStorage.instance.ref().child('userImage/$username.jpg');
        await ref.putFile(image).then((p0) => print(p0.metadata?.fullPath));
        final imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': imageUrl,
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

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'CONVERSE',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
              //backgroundColor: Colors.pink,
              decoration: TextDecoration.overline,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          AuthForm(submitForm),
        ],
      ),
    );
  }
}
