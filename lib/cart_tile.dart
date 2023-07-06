
import 'package:authenticate/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/note.dart';

class CartTile extends StatefulWidget {
  final Note kart;
  final onDelete;
  final onChange;

  const CartTile({Key? key, required this.kart, required this.onDelete,required this.onChange}):super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}


class _CartTileState extends State<CartTile> {

  User? user;
  String? userId ;
  int? price;
  int number =0;
  int? num;



  late Future<List<Note>> cart;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    num = int.parse(widget.kart.quantity);
    // List<int> number = List.generate(widget.kart.quantity.length,(index)=>0);
    price = int.parse(widget.kart.price);
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid.toString();
    _firestore = FirebaseFirestore.instance;
    cart = fetchNotes();
  }

  Future<List<Note>> fetchNotes() async{
//call firestore ..documents
    var result = await _firestore.collection(userId!).get();
    if(result.docs.isEmpty){
      return [];
    }
    var notes = <Note>[];
    for(var doc in result.docs){
      notes.add(Note.fromMap(doc.data()));
    }
    return notes;
  }

  void _editItem() async {
    var uid = widget.kart.uid; // Get the UID of the note you want to update
    var docRef = _firestore.collection(userId!).doc(uid);

    print('${num!+number}');
    // Create a map of the fields you want to update
    var updatedData = {
      'quantity': num!+number,
    };


    try {
      await docRef.update(updatedData);
      print('Data updated successfully');
      setState(() {
        // Update the local state to reflect the changes
        cart = fetchNotes();

      });
    } catch (error) {
      print('Error updating data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    int? value = num!+number;
    return Container(
      key: Key(widget.kart.uid),
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
                        child: Image.network(widget.kart.image,fit: BoxFit.fill,height: 80,width: 80,),),
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
                        child: Text(widget.kart.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color:Colors.black,fontSize: 17,fontWeight: FontWeight.bold ),),
                      ),
                      // SizedBox(height: 10,),
                      Text(widget.kart.type,
                        overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 20,),
                      Container(

                        child: Row(
                          children: [
                            Icon(size: 18,
                                weight: 50,
                                Icons.currency_rupee,

                            ),
                            Text('${price!*value}',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            // Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(child: Container()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: ()=>widget.onDelete(),
                        icon: Icon(Icons.delete)),
                    Container(
                      decoration:BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        children: [
                          GestureDetector(

                            onTap: (){

                              setState(() {

                                if(value>1){
                                  number--;
                                  _editItem();
                                  widget.onChange();
                                 cart =fetchNotes();
                                }

                              });
                            },

                            child:Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                              child: Text('-',style: TextStyle(color: Colors.black,fontSize: 25),),
                            ) ,
                          ),

                          Text('${value}',style: TextStyle(fontSize:14),),
                          GestureDetector(
                            onTap: (){

                              setState(() {

                                if(value>=1){
                                  number++;
                                  _editItem();
                                  widget.onChange();
                                  cart = fetchNotes();
                                }

                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                              child: Text('+',style: TextStyle(fontSize: 20,color: Colors.black),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
