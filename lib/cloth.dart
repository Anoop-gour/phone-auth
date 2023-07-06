import 'package:authenticate/content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/note.dart';


class ClothsScreen extends StatefulWidget {
  const ClothsScreen({Key? key, required this.heading,required this.fields}) : super(key: key);
  final heading;
  final dynamic fields;

  @override
  State<ClothsScreen> createState() => _ClothsScreenState();
}

class _ClothsScreenState extends State<ClothsScreen> {



  late Future<List<Note>> cloth;
  late FirebaseFirestore firestore;

  Future<List<Note>> fetchNotes() async{
//call firestore ..documents
    var result = await firestore.collection(widget.fields).get();
    if(result.docs.isEmpty){
      return [];
    }
    var cloths = <Note>[];
    for(var doc in result.docs){
      cloths.add(Note.fromMap(doc.data()));
    }
    return cloths;
  }

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    cloth = fetchNotes();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
                children: [
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ink(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle
                  ),
                  child: InkWell(
                    onTap: (){Navigator.pop(context);},focusColor: Colors.white,
                    child: Icon(Icons.navigate_before,color: Colors.white,size: 40,),
                  ),
                ),
                Expanded(child: Container(),),
                IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.search,color: Colors.black54,),

                    ),
              ],
            ),
          ),
                  Text(widget.heading,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  SizedBox(height: 10,),
                  Expanded(
                    child: FutureBuilder(
                      future: cloth,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Center(
                            child:CircularProgressIndicator(), );
                        }
                        if((snapshot.data as List).isEmpty){
                          return Center(child: Text('No Data Found'),);
                        }
                        return RefreshIndicator(
                          onRefresh: ()async{
                            setState(() {
                              cloth = fetchNotes();
                            });
                          },
                          child: GridView.builder(
                              itemCount: (snapshot.data as List).length,
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                childAspectRatio: 1 / 1.7,
                                maxCrossAxisExtent: 200,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return Content(
                                  cloth: snapshot.data![index],
                                );
                              }
                          ),
                        );
                      }
                    ),
                  ),
          ],
    ),
          ),
        ),
      ),
    );
  }
}
