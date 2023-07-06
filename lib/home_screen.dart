import 'package:authenticate/cloth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/note.dart';


class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {




  final List<Map<String,dynamic>> imageList = [
    {'Image_Path':'assets/images/new.png'},
    {'Image_Path':'assets/images/cloth.png'},
    {'Image_Path':'assets/images/bags.png'},
    {'Image_Path':'assets/images/shoes.png'},
    {'Image_Path':'assets/images/electronics.png'},

  ];

  List name  =[
    'New Arrivals','Clothes','Bags','Shoes','Electronics'
  ];

  List Quantity = [
    '0','6','6','0','0'
  ];

  List screen = [
   ClothsScreen(heading: 'New Arrivals',fields: 'new arrival',),
   ClothsScreen(heading: 'Clothes',fields: 'cloths',),
   ClothsScreen(heading: 'Bags',fields: 'bags',),
   ClothsScreen(heading: 'Shoes',fields: 'shoes',),
   ClothsScreen(heading: 'Electronics',fields: 'electronic',),
  ];



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
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
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade200
              ),
              child: TextFormField(
                cursorColor: Colors.black54,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Categories',
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.black54
                ),
              ),
            ),

            SizedBox(height: 10,),
            Expanded(
                      child: ListView.builder(
                          itemCount: imageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String image = imageList[index]['Image_Path'];
                            String title = name[index];
                            String quantity = Quantity[index];
                            var sc = screen[index];
                            if (index % 2 == 0) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => sc));
                                  },
                                  child: Container(
                                      height: 115,
                                      // padding: EdgeInsets.symmetric(horizontal: 130,vertical: 18),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          border: Border.all(
                                              color: Colors.grey.shade200),
                                          borderRadius: BorderRadius.circular(
                                              20)
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          SizedBox(width: 20,),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              Text(title, style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight
                                                      .bold),),
                                              Text(quantity + ' Product')
                                            ],
                                          ),
                                          Expanded(child: Container()),
                                          Image.asset(image, fit: BoxFit.cover,
                                            width: 200,)

                                        ],
                                      )
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>sc));
                                  },
                                  child: Container(
                                      height: 115,
                                      // padding: EdgeInsets.symmetric(horizontal: 130,vertical: 18),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          border: Border.all(
                                              color: Colors.grey.shade200),
                                          borderRadius: BorderRadius.circular(
                                              20)
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          SizedBox(width: 20,),
                                          Image.asset(image, fit: BoxFit.cover,
                                            width: 200,),
                                          Expanded(child: Container()),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              Text(title, style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight
                                                      .bold),),
                                              Text(quantity + ' Product'),

                                            ],
                                          ),
                                          Expanded(child: Container())
                                        ],
                                      )
                                  ),
                                ),
                              );
                            }
                          }
                      ),

            ),
      ],
        ),
      ),
    );
  }
}