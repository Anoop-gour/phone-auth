
import 'package:authenticate/buttons.dart';
import 'package:authenticate/note_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';


import 'models/note.dart';
import 'note_tile.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MyHomePage(title: 'CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  late Future<List<Note>> _notes;
  late FirebaseFirestore _firestore;

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

  void _addItem()async{
    if(imageUrl.isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload an image')));
      return;
    }

    var uid = _firestore.collection('notes').doc().id;
    await _firestore.collection('notes').doc(uid).set({
      'title':_itemName.text,
      'uid' : uid,
      'price': _price.text,
      'location':_location.text,
      'image' : imageUrl,
    });
    _itemName.clear();
    _price.clear();
    _location.clear();
    _description.clear();
    Navigator.pop(context);
    setState(() {
      _notes = fetchNotes();
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _notes = fetchNotes();
  }

  var _validKey = GlobalKey<FormState>();

  TextEditingController _itemName = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _description = TextEditingController();


  String imageUrl = '';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            title: Text(widget.title),

          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            onPressed: (){
              showDialog(context: context, builder: (_)=>AlertDialog(
                title: Text('Add item',style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                content:SingleChildScrollView(
                  child: Form(
                    key: _validKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Item Name'),
                        TextFormField(
                          controller: _itemName,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Enter item name';
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        Text('Price'),
                        TextFormField(
                          controller: _price,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Enter Item price';
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        Text('Location'),
                        TextFormField(
                          controller: _location,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Enter Location';
                            }else{
                              return null;
                            }
                          },

                        ),
                        SizedBox(height: 10,),
                        Text('Description'),
                        TextFormField(
                          controller: _description,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Enter item description';
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        Center(
                          child: ElevatedButton(onPressed: ()async{
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                            print('${file?.path}');

                            if(file == null) return;

                            String uniqueFileName =  DateTime.now().millisecondsSinceEpoch.toString();

                            Reference referenceRoot = FirebaseStorage.instance.ref();
                            Reference referenceDirImages = referenceRoot.child('images');

                            Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                            try {
                              await referenceImageToUpload.putFile(File(file!.path));

                              imageUrl = await referenceImageToUpload.getDownloadURL();

                            }catch(error){
                              print(error);
                            }

                          },
                              child: Text('Add Picture'),),
                        )

                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: (){
                        if(_validKey.currentState!.validate()){
                          return _addItem();
                        }else{
                          return null;
                        }

                  },
                      child: Text('Add'),
                  ),
                ],
              ),
              );
            },
            child: Icon(Icons.add),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _notes,
                  builder: (context, snapshot){
                    if(snapshot.connectionState== ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),);
                    }
                    if((snapshot.data as List).isEmpty){
                      return Center(child: Text('No Data Added'),);
                    }
                     return RefreshIndicator(
                       onRefresh: ()async{
                         setState(() {
                           _notes = fetchNotes();
                         });
                       },
                       child: ListView.builder(
                           itemCount:(snapshot.data as List).length,
                           itemBuilder: (context, index){
                         return NoteTile(
                             note: snapshot.data![index]


                         );

                       }),
                     );
                  },
                ),
              ),
            ],
          )

        ),
      ),
    );
  }
}
