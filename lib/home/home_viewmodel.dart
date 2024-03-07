import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  Stream? getData;
  TextEditingController nameController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fetchData() async {
    getData = FirebaseFirestore.instance.collection('client').snapshots();

    notifyListeners();
  }

  Future<void> addData() async {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    String id = getRandomString(10);

    final user = <String, dynamic>{
      "name": nameController.text,
    };

// Add a new document with a generated ID
    db.collection("client").doc(id).set(user);

    nameController.clear();

    fetchData();
    notifyListeners();
  }

  String? selectedId;

  Future<void> clickName(String name, String id) async {
    nameController.text = name;

    selectedId = id;
    notifyListeners();
  }

  Future<void> updateData() async {
    final user = <String, dynamic>{
      'name': nameController.text,
    };

    db.collection('client').doc(selectedId).set(user);

    fetchData();

    notifyListeners();
  }
}
