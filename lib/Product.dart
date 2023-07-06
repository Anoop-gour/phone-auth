
import 'package:authenticate/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'models/note.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.detail});
  final Note detail;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  User? user;
  String? userId ;
  int? price;

  late Future<List<Note>> _notes;
  late FirebaseFirestore _firestore;

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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message)),
    );
  }

  void _addItem()async{

    // Check if a size is selected
    if (isSelected.every((element) => element == false)) {
      _showError('Please select a size');
      return ;
    }

    // Check if a color is selected
    if (isSelectedColor.every((element) => element == false)) {
      _showError('Please select a color');
      return;
    }


    var uid = _firestore.collection(userId!).doc().id;
    await _firestore.collection(userId!).doc(uid).set({
      'uid' : uid,
      'price': price,
      'name' : widget.detail.name,
      'image' : widget.detail.image,
      'type' : widget.detail.type,
      'quantity' : number,
      'size' : sizes
        .asMap()
        .entries
        .where((entry) => isSelected[entry.key])
        .map((entry) => entry.value)
        .single,
      'color' : colors.asMap().entries.where((element) => isSelectedColor[element.key]).map((e) => e.value).first,

    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen(fields: userId)));
    setState(() {
      _notes = fetchNotes();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid.toString();
    price = int.parse(widget.detail.price);
    _firestore = FirebaseFirestore.instance;
    _notes = fetchNotes();

  }



  int number =1;
  double Rate = 0;



  List<bool> isSelected = [
    false,false,false,false,false
  ];

  List isSelectedColor = [
    false,false,false,false
  ];

  List sizes = [
    'S','M','L','XL','XXL'
  ];

  List colors = [
    0xFFFFFFFF,0xFF000000,0xFFFFD54F,0xFF64B5F6,

  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          body: Container(
            color: Colors.grey.shade400,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 20,right: 25),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle
                                ),
                                child: InkWell(
                                  onTap: (){Navigator.pop(context);},
                                  child: Icon(Icons.navigate_before,color: Colors.white,size: 40,),
                                ),
                              ),
                              Expanded(child: Container(),),
                              Container(
                                decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                                child:FutureBuilder(
                                    future: _notes,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if((snapshot.data as List).isEmpty){
                                        return Center(child: Text('0'),);
                                      }
                                      return RefreshIndicator(
                                        onRefresh: ()async{
                                          setState(() {
                                            _notes = fetchNotes();
                                          });
                                        },
                                        child: IconButton(
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen(fields: userId) ));
                                          },
                                          icon: Badge(
                                              label: Text('${(snapshot.data as List).length}'),
                                              child: Icon(Icons.shopping_bag_outlined,color: Colors.black54,)),

                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(widget.detail.image,fit: BoxFit.fill,height: 300,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 30,left: 20,right: 25,bottom: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.detail.name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),),
                                        SizedBox(height: 5,),
                                        Text(widget.detail.type,style: TextStyle(fontSize: 16),),
                                        SizedBox(height: 5,),
// Review Star
                                      RatingBar.builder(
                                          itemBuilder: (context, index) => Icon(Icons.star,color: Colors.amber,),
                                          itemCount: 5,
                                          direction: Axis.horizontal,
                                          itemSize: 20,
                                          maxRating: 5,
                                        minRating: 1,
                                        initialRating: 3.5,
                                        ignoreGestures: true,
                                        allowHalfRating: true,
                                        updateOnDrag: true,
                                        onRatingUpdate: (Ratingvalue){
                                            setState(() {
                                              Rate = Ratingvalue  ;
                                            });
                                          },
                                      )
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Column(
                                      children: [
                                        Container(
                                          decoration:BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(30)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(

                                                  onTap: (){
                                                    setState(() {
                                                      if(number>1){
                                                      number--;
                                                      }
                                                    });
                                                  },
                                                  // behavior: ,
                                                  child:Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                                                    child: Text('-',style: TextStyle(color: Colors.black,fontSize: 25),),
                                                  ) ),

                                              Text(number.toString(),style: TextStyle(fontSize:18),),
                                              GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      if(number>=1){
                                                        number++;
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                                                    child: Text('+',style: TextStyle(fontSize: 25,color: Colors.black),),
                                                  ),)
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text('Available In Stock',style: TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25,),
                                Text('Size',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                // SizedBox(height: 15 ,),
                                Container(
                                  height: 65,
                                  child: ListView.builder(
                                    // padding: EdgeInsets.all(8),
                                    itemCount: sizes.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index){
                                      String size = sizes[index];
                                      bool isSelectedSize = isSelected[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                isSelected = List.generate(isSelected.length, (i) => i== index);

                                              });
                                            },
                                            child: Container(
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: isSelectedSize ? Colors.black:Colors.white,
                                                border: Border.all(color: Colors.black),
                                                shape: BoxShape.circle,

                                              ),
                                              child: Center(
                                                  child: Text(size,
                                                    style: TextStyle(fontWeight: FontWeight.bold,
                                                    color: isSelectedSize?Colors.white:Colors.black
                                                    ),)),
                                            ),
                                          ),
                                        );

                                      }
                                      ),
                                ),

     // color
                                SizedBox(height: 10,),
                                Text('Color',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                // SizedBox(height: 15 ,),
                                Container(
                                  height: 60,
                                  child: ListView.builder(
                                    // padding: EdgeInsets.all(8),
                                    itemCount: colors.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index){
                                      int color = colors[index];
                                      bool isColor = isSelectedColor[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                isSelectedColor = List.generate(isSelectedColor.length, (i) => i== index);

                                              });
                                            },
                                            child: Container(
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Color(color),
                                                border: Border.all(color: Colors.grey),
                                                shape: BoxShape.circle,
                                              ),
                                              child: isColor
                                                  ?Icon(Icons.check_outlined,color: Colors.redAccent,)
                                                  :null

                                            ),
                                          ),
                                        );
                                      }
                                      ),
                                ),
                                SizedBox(height: 10,),
                                Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                                SizedBox(height: 5,),
                                Text(widget.detail.description)
                              ],
                            ),
                          ),

                        ),

                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 90,
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total price'),
                          Text('Rs ${(price)!*number}',style: TextStyle(
                            fontSize: 22,fontWeight: FontWeight.bold
                          ),
                          ),
                        ],
                      ),

                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: (){
                          return _addItem();
                        },
                        child: Container(
                            width: 200,
                          decoration: BoxDecoration(
                            color: Colors.black,borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined,color: Colors.white,),
                              SizedBox(width:15,height: 60,),
                              Text('Add to cart',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 25,)
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
}
