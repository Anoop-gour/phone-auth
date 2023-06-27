class Note{
  late String  uid, title,price,location,description;
  String image = '';

  Note.fromMap(Map m)
      : uid = m['uid'].toString(),
        title =  m['title'].toString(),
        price = m['price'].toString(),
        location = m['location'].toString(),
        description = m['description'].toString(),
        image = m['image'].toString();
}