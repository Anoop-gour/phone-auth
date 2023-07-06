
import 'package:authenticate/cloth.dart';
import 'package:authenticate/main_screen.dart';
import 'package:authenticate/slider/carousel_screen.dart';
import 'package:authenticate/login_page.dart';
import 'package:authenticate/login_signup.dart';
import 'package:authenticate/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'models/note.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late Future<List<Note>> cloth;
  late FirebaseFirestore firestore;

  Future<List<Note>> fetchNotes() async{
//call firestore ..documents
    var result = await firestore.collection('cloths').get();
    if(result.docs.isEmpty){
      return [];
    }
    var cloth = <Note>[];
    for(var doc in result.docs){
      cloth.add(Note.fromMap(doc.data()));
    }
    return cloth;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        'splash' : (context) => SplashScreen(),
        'loginsignup' : (context) => LoginSignup(),
        'login' : (context)  => LoginPage(),
        'carousel' : (context) => CarouselSlider(),
        'main' : (context) => MainScreen(),
       },
    );
  }
}
