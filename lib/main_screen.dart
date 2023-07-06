import 'package:authenticate/cart_screen.dart';
import 'package:authenticate/home_screen.dart';
import 'package:authenticate/notification.dart';
import 'package:authenticate/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/note.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {

  User? user;
  String? userId ;

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
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid.toString();
      firestore = FirebaseFirestore.instance;
      cloth = fetchNotes();
    _selectedLabel=_getLabel(_selectedIndex);
  }
  int _selectedIndex = 0;
  var _selectedLabel;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedLabel = _getLabel(index);
    });
  }

  _getLabel(int index) {
    switch (index) {
      case 0:
        return  HomeScreen();
      case 1:
        return  CartScreen(fields: userId,);
      case 2:
        return  NotificationScreen();
      case 3:
        return  ProfileScreen(Id: userId);
      default:
        return  HomeScreen();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
          body: Center(
            child: _selectedLabel,

          ),

          bottomNavigationBar: BottomNavigationBar(

            selectedItemColor: Colors.black,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[



              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled,color: Colors.black,),
                label: 'Home',

              ),
              BottomNavigationBarItem(

                icon: Icon(Icons.shopping_cart,color: Colors.black,),
                label: 'Cart',

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications,color: Colors.black,),
                label: 'notification',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person,color: Colors.black,),
                  label:'profile',

              ),


            ],
          ),

          ),

      );
  }
}
