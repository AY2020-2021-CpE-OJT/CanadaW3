import 'package:flutter/material.dart';

class NoContact extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No Contacts Listed',
            style: TextStyle(fontSize: 20),
          ),
        ],
      )
    );
  }
}