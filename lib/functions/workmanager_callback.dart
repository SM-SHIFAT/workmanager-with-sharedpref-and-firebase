import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

import '../model/firebase_model.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {
    SharedPreferencesAndroid.registerWith();
    await Firebase.initializeApp();

    try {
      //SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('value', 100);
      final int? value = prefs.getInt('value');
      print("SharedPreferences value = $value");

      //Firebase
      final dataFromFirebase = await readsingleFirebaseData();
      if (dataFromFirebase != null) {
        print("Data1 = ${dataFromFirebase.data1}");
        print("Data2 = ${dataFromFirebase.data2}");
        print("Data3 = ${dataFromFirebase.data3}");
        print("Data4 = ${dataFromFirebase.data4}");
      } else {
        return false;
      }
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }

    return true;
  });
}

//Read data from firebase
Future<FirebaseModel?> readsingleFirebaseData() async {
  final docData =
      await FirebaseFirestore.instance.collection("example").doc("value");
  final snapshot = await docData.get();

  if (snapshot.exists) {
    return FirebaseModel.fromJson(snapshot.data()!);
  } else {
    return null;
  }
}
