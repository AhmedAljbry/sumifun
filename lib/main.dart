import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumfiun/Core/LocaleProvider.dart';
import 'package:sumfiun/Primery_App.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAvUGU3VGbnru7oRtDCrIfA_bcm0Qodjiw",
      authDomain: "loginfierbase-c4bc0.firebaseapp.com",
      projectId: "loginfierbase-c4bc0",
      storageBucket: "loginfierbase-c4bc0.appspot.com",
      messagingSenderId: "88867532408",
      appId: "1:88867532408:web:019fb1b9582304549ac78d",
    ),

  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const PrimaryApp(),
    ),
  );
}
void testConnection() {
  FirebaseFirestore.instance
      .collection('test')
      .add({'message': 'Firebase connected!'})
      .then((value) => print("تمت الإضافة بنجاح"))
      .catchError((error) => print("فشل الاتصال: $error"));
}