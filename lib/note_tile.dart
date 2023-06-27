
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'models/note.dart';

class NoteTile extends StatefulWidget {
  final Note note;

  const NoteTile({Key? key, required this.note}):super(key: key);

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {



  late Future<List<Note>> _notes;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _notes = fetchNotes();
  }

  Future<List<Note>> fetchNotes() async{
//call firestore ..documents
    var result = await _firestore.collection('notes').get();
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
    var uid = widget.note.uid; // Get the UID of the note you want to update
    var docRef = _firestore.collection('notes').doc(uid);

    // Create a map of the fields you want to update
    var updatedData = {
      'title': aitemname.text,
      'price': aprice.text,
      'location': alocation.text,
      'description': adescription.text,
      'image' : widget.note.image,
    };


    try {
      await docRef.update(updatedData);
      print('Data updated successfully');
      setState(() {
        // Update the local state to reflect the changes
        _notes = fetchNotes();
      });
    } catch (error) {
      print('Error updating data: $error');
    }
  }


  TextEditingController aitemname = TextEditingController();
  TextEditingController aprice = TextEditingController();
  TextEditingController alocation = TextEditingController();
  TextEditingController adescription = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(widget.note.uid),
      margin: EdgeInsets.all(1),
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          color: Colors.black12,offset: Offset(1,2),blurRadius: 10
        ),]
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: (){},
          child: Container(width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white,
                border: Border.all(color: Theme.of(context).focusColor),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.note.image,fit: BoxFit.cover,height: 60,width: 60,)),
                ),
                SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.only(top: 8,bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Text(widget.note.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold ),),

                      ),
                      Row(
                        children: [
                          Icon(size: 12,
                              Icons.currency_rupee
                          ),
                          Text(widget.note.price,overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Row(
                          children: [
                            Icon(size: 12,
                              Icons.location_pin,
                            ),
                            Text(widget.note.location,
                            overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext){
                          return AlertDialog(
                            title: Text('Edit item'),
                            content:SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Item Name'),
                                  TextFormField(
                                    controller: aitemname,

                                  ),
                                  SizedBox(height: 10,),
                                  Text('Price'),
                                  TextFormField(
                                    controller: aprice,
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Location'),
                                  TextFormField(
                                    controller: alocation,
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Description'),
                                  TextFormField(
                                    controller: adescription,
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: ElevatedButton(onPressed: (){

                                    },
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal)),
                                      child: Text('Add Picture'),),
                                  )

                                ],
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed:_editItem,
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal),),
                                  child: Text('Edit'))

                            ],
                          );
                        });
                  }, icon: Icon(Icons.edit)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
