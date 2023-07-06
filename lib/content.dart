import 'package:authenticate/Product.dart';
import 'package:flutter/material.dart';
import 'models/note.dart';

class Content extends StatefulWidget {
  const Content({super.key, required this.cloth});
  final Note cloth;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(detail: widget.cloth)));
      },
      child: Column(
        children: [
          Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              // height: 250,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(
                      20)
              ),
              child: Image.network(
                widget.cloth.image,
                fit: BoxFit.fill, height: 210,)
          ),
          SizedBox(height: 5,),
          Text(widget.cloth.name,
            style: TextStyle(color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold),),
          SizedBox(height: 3,),
          Text(widget.cloth.type),
          SizedBox(height: 3,),

          Text('Rs ${widget.cloth.price.toString()}')
        ],
      ),
    );
  }
}
