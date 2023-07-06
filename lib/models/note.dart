class Note{
  late String  uid, type,name,price,description,color,quantity,size;
  String image = '';
  // double price;

  Note.fromMap(Map m)
      : uid = m['uid'].toString(),
        type =  m['type'].toString(),
        price = m['price'].toString(),
        name = m['name'].toString(),
        image = m['image'].toString(),
        description = m['description'].toString(),
        color = m['color'].toString(),
        quantity = m['quantity'].toString(),
        size = m['size'].toString()



  ;
}