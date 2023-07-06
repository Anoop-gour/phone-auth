import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.Id});
  final Id;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('User Id = $Id'),
      ),

       );
  }
}
