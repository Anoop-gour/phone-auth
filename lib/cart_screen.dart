import 'dart:ui';

import 'package:authenticate/cart_tile.dart';
import 'package:authenticate/content.dart';
import 'package:authenticate/proceed.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/note.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key,required this.fields}) : super(key: key);
  final dynamic fields;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


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
                          Navigator.pushNamed(context, 'main');},focusColor: Colors.white,
                        child: Icon(Icons.navigate_before,color: Colors.white,size: 40,),
                      ),
                    ),
                    Expanded(child: Container(),),
                    FutureBuilder(
                        future: cart,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if((snapshot.data as List).isEmpty){
                            return Center(child: Text('0'),);
                          }
                          return RefreshIndicator(
                            onRefresh: ()async{
                              setState(() {
                                cart = fetchNotes();
                              });
                            },
                            child: IconButton(
                              onPressed: (){},
                              icon: Badge(
                                  label: Text('${(snapshot.data as List).length}'),
                                  child: Icon(Icons.shopping_bag_outlined,color: Colors.black54,)),

                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
              Text('My Cart',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
                              height: 400,
                              child: ListView.builder(
                                  itemCount: (snapshot.data as List).length,

                                  itemBuilder: (context, index) {
                                    return CartTile(
                                      kart: snapshot.data![index],
                                      onDelete: ()async{
                                        await firestore
                                            .collection(widget.fields)
                                            .doc((snapshot.data![index] as Note).uid)
                                            .delete();
                                        setState(() {
                                          cart =fetchNotes();
                                        });
                                      },
                                      onChange: ()async{
                                        setState(() {
                                          cart = fetchNotes();
                                        });
                                      },
                                    );
                                  }
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade200)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('SubTotal',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                        Expanded(child: Container()),
                                        Icon(Icons.currency_rupee),
                                        Text(('${subtotal}'),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text('Shipping',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                        Expanded(child: Container()),
                                        Icon(Icons.currency_rupee),
                                        Text('$shipping',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text('BagTotal',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                        Expanded(child: Container()),
                                        Icon(Icons.currency_rupee),
                                        Text('${subtotal+shipping}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProceedScreen(fields: widget.fields)));
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
