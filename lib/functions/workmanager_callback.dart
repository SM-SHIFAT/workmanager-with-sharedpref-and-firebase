import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart'; //For Android devices
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart'; //For IOS/macos devices
//import 'package:shared_preferences_ios/shared_preferences_ios.dart'; //For IOS devices
//import 'package:shared_preferences_macos/shared_preferences_macos.dart'; //For macos devices
import 'package:shared_preferences_linux/shared_preferences_linux.dart'; //For linux devices
import 'package:shared_preferences_windows/shared_preferences_windows.dart'; //For windows devices
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import '../model/firebase_model.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {
    if (Platform.isAndroid) {
      SharedPreferencesAndroid.registerWith(); //For Android devices
    } else if (Platform.isIOS) {
      SharedPreferencesFoundation.registerWith(); //For IOS/Macos devices
    }

    await Firebase.initializeApp();

    try {
      //--------------SharedPreferences--------------
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('value', 100);
      final int? value = prefs.getInt('value');
      print("SharedPreferences value = $value");

      //-------------------Firebase-------------------
      final dataFromFirebase = await readAndWriteFirebaseData();
      if (dataFromFirebase != null) {
        print("Firebase Data1 = ${dataFromFirebase.data1}");
        print("Firebase Data2 = ${dataFromFirebase.data2}");
        print("Firebase Data3 = ${dataFromFirebase.data3}");
        print("Firebase Data4 = ${dataFromFirebase.data4}");
      } else {
        return false; //If False returned that means task is failed and will be retry.
      }
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }

    return true; //If True returned that means task is successfully completed.
  });
}

//Read data from firebase
Future<FirebaseModel?> readAndWriteFirebaseData() async {
  // Fetch from Firebase
  final docData = FirebaseFirestore.instance.collection("example").doc("value");
  final snapshot = await docData.get();

  // Add to Firebase
  FirebaseFirestore.instance.collection("example").add({"data": "mydata1"});

  if (snapshot.exists) {
    return FirebaseModel.fromJson(snapshot.data()!);
  } else {
    return null;
  }
}
