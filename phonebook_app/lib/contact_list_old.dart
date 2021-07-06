import 'package:flutter/material.dart';
import 'package:phonebook_app/data.dart';

class ContactList extends StatelessWidget {
  final List<Data> data;

  const ContactList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Flexible(child: ListView.builder(
                itemCount: data.length, itemBuilder: (context, index){
              return Container(
                child: ListTile(
                  title: Text('Name: ${data[index].first_name} ${data[index].last_name}' + '\nPhone Numbers: ' + '${data[index].phone_numbers}'),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }
}