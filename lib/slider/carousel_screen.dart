import 'package:authenticate/home_screen.dart';
import 'package:authenticate/main_screen.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({super.key});

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {

  List<Map<String,dynamic>>Slider = [
    {"image_path" : 'assets/images/bg2.png',
      'title':'20% Discount New Arrival Product',
      'subtitle':'Publish up your selfies to make yourself more beautiful with this app.'},
    {"image_path" : 'assets/images/bg3.png',
      'title':'Take Advantage Of The Offer Shopping',
      'subtitle':'Publish up your selfies to make yourself more beautiful with this app.'},
    {"image_path" : 'assets/images/bg1.png',
      'title':'All Type Of Offer Within Your Reach',
      'subtitle':'Publish up your selfies to make yourself more beautiful with this app.'},
  ];

  final CarouselController carouselController = CarouselController();
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: currentIndex==2
          ?FloatingActionButton(
        backgroundColor: Colors.black,
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => MainScreen(),
            ),
            );
          },
              child: Icon(Icons.navigate_next_sharp),
      )
          :FloatingActionButton(
          onPressed:(){
            setState(() {
              currentIndex++;
              pageController.animateToPage(
                  currentIndex,
                  duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            });
          },
        backgroundColor: Colors.black,
        child: Icon(Icons.navigate_next_sharp),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Handle tap event on the image
                    // You can navigate to a detail page or perform other actions
                  },
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: Slider.length  ,
                    // physics: const ClampingScrollPhysics( ),
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height/2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image:DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(Slider[index]['image_path'])
                                  )
                              ),
                            ),
                            SizedBox(height: 30,),
                            Text(
                                Slider[index]['title'],
                                style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold)),
                            SizedBox(height: 10,),
                            Text(
                              Slider[index]['subtitle'],
                              style: TextStyle(fontSize: 15,color: Colors.grey),)

                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                  _buildIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    return List<Widget>.generate(Slider.length, (index) {
      return Container(
        width: index==currentIndex ? 20 : 7,
        height:8.0,
        margin: EdgeInsets.only(bottom: 30,right: 4,left: 4),
        decoration: BoxDecoration(
          // shape: index== currentIndex ? BoxShape.rectangle :BoxShape.circle,
          color: index == currentIndex ? Colors.black : Colors.grey,
          borderRadius: BorderRadius.circular(50)
        ),
      );
    });
  }
}
