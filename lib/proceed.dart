import 'dart:ui';

import 'package:authenticate/cart_tile.dart';
import 'package:authenticate/content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/note.dart';


class ProceedScreen extends StatefulWidget {
  const ProceedScreen({Key? key,required this.fields}) : super(key: key);
  final dynamic fields;

  @override
  State<ProceedScreen> createState() => _ProceedScreenState();
}

class _ProceedScreenState extends State<ProceedScreen> {


  int shipping = 17;


  late Future<List<Note>> cart;
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
    cart = fetchNotes();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Padding(
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
                        onTap: (){
                          Navigator.pop(context);},focusColor: Colors.white,
                        child: Icon(Icons.navigate_before,color: Colors.white,size: 40,),
                      ),
                    ),
                   
                  ],
                ),
              ),
              Text('Delivery Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).focusColor),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text('Vijay Nagar, Indore, 452011'),
              ),SizedBox(height: 10,),
              Text('Product Item',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 10,),
              Expanded(
                child: FutureBuilder(
                    future: cart,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(
                          child:CircularProgressIndicator(), );
                      }
                      if((snapshot.data as List).isEmpty){
                        return Center(child: Text('No Data Found'),);
                      }

                      int subtotal = 0;
                      for (var note in snapshot.data as List<Note>) {
                        subtotal += int.parse(note.price)*int.parse(note.quantity);
                      }
                      return RefreshIndicator(
                        onRefresh: ()async{
                          setState(() {
                            cart = fetchNotes();
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 200,
                              child: ListView.builder(
                                  itemCount: (snapshot.data as List).length,

                                  itemBuilder: (context, index) {
                                    return Container(
                                      key: Key(widget.fields.uid),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: GestureDetector(
                                          onTap: (){

                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(color: Colors.white,
                                                // border: Border.all(color: Theme.of(context).focusColor),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey.shade200,
                                                        borderRadius: BorderRadius.circular(15)
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.network(widget.fields.image,fit: BoxFit.fill,height: 80,width: 80,),),
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 8,bottom: 8),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(),
                                                        child: Text(widget.fields.name,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(color:Colors.black,fontSize: 17,fontWeight: FontWeight.bold ),),
                                                      ),
                                                      // SizedBox(height: 10,),
                                                      Text(widget.fields.type,
                                                        overflow: TextOverflow.ellipsis,),
                                                      SizedBox(height: 20,),
                                                      Container(

                                                        child: Row(
                                                          children: [
                                                            Icon(size: 18,
                                                              weight: 50,
                                                              Icons.currency_rupee,

                                                            ),
                                                            Text('',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                            // Expanded(child: Container()),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                            SizedBox(height: 10,),

                          ],
                        ),
                      );
                    }
                ),
              ),
              Text('Promo Code',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(child: Text('Proceed to Checkout',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),)),
                ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
