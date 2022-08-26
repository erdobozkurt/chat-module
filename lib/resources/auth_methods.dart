
import 'package:chat_module/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/chat_page.dart';
import '../screens/login_page.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //* Sign up a user
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String secPassword,
    required PickedFile avatar,
    required BuildContext context,
  }) async {

    try {
      if (password.trim() == secPassword.trim()) {
        await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        String urlDownload = await StorageMethods().uploadImage(avatar);

        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set({
          'senderId': _auth.currentUser!.uid,
          'email': _auth.currentUser!.email,
          'name': name,
          'avatar': urlDownload,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('check the password'),
          ),
        );
        return;
      }

      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, ChatPage.routeName);
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code.toString()),
        ),
      );
    } catch (e) {
      throw Exception('fail on sign up');
    }
  }

  //* Sign in a user
  Future signIn({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, ChatPage.routeName);
          
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.code.toString(),
          ),
        ),
      );
    }
  }

  //* sign out a user
  Future signOut({
   required BuildContext context
  }) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    });
  }
}