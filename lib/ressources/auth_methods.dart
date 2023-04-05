import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/ressources/storage_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/utils/global_variables.dart';

import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDatails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
}) async {
    String res = "Some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        //add user to our database

        model.User user = model.User(
          uid : cred.user!.uid,
          email : email,
          photoUrl : photoUrl,
          username : username,
          bio : bio,
          followers : [],
          following : [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);
        res = 'success';
      }
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }

  //logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        homeScreenItems.last = ProfileScreen(
          uid: FirebaseAuth.instance.currentUser!.uid,
        );
        res = 'success';
      }else{
        res = "Please enter all the fields";
      }
    }catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut(context) async {

    await _auth.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

}