import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_itelective/pages/users.dart';

class DatabaseService {
  final _fireStore = FirebaseFirestore.instance;

  create(User user) {
    try {
      _fireStore.collection("users").add({
        "firstname": user.firstname,
        "lastname": user.lastname,
        "username": user.username,
        "email": user.firstname,
        "isActive": 1
      });
    } catch (e) {
      log("Error: $e");
    }
  }

  read() async {
    try {
      final data = await _fireStore.collection("users").get();
      final users = data.docs[2];
      log(users["firstname"]);
      log(users["lastname"]);
      log(users["username"]);
      log(users["email"]);
    } catch (e) {
      log("Error: $e");
    }
  }

  update() async {
    try {
      await _fireStore.collection("users").doc("2fdRTDJuoN8ontZXtmXm").update({
        "firstname": "Elliot",
        "lastname": "Alderson",
        "username": "mrrobot",
        "email": "elliotalderson@gmail.com",
        "isActive": 1
      });
    } catch (e) {
      log("Error: $e");
    }
  }

  delete() async {
    try {
      await _fireStore.collection("users").doc("54VCK0uwx1Yvy6UK5Gs1").delete();
    } catch (e) {
      log("Error: $e");
    }
  }
}
