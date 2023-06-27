import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  // final Function changed;
  final String title;

  const ChipButton({Key? key, required this.title,})
  :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: (){

        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
