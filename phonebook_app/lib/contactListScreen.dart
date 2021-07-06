import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phonebook_app/data.dart';
import 'noContacts.dart';

class ContactsList extends StatefulWidget{
  final List<Data> dataList;
  ContactsList({Key? key, required this.dataList}) : super(key: key);

  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactsList> {

  @override
  void initState(){
    super.initState();
  }

  Widget phoneNumbersList(int index){
    return new Container(
      child: Column(
        children: widget.dataList[index].phone_numbers.map((x) => Text(x, style: TextStyle(fontWeight: FontWeight.w500),)).toList(),
      ),
    );
  }

  Widget buildDataCard(BuildContext context, int index){
    final data = widget.dataList[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                     flex: 2,
                     child: Row(
                       children: [
                         Expanded(
                           flex: 1,
                           child: Row(
                           children: [
                             SizedBox(width: 12.0),
                             CircleAvatar(
                               backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                               radius: 25.0,
                               child: Text('${data.first_name[0]}${data.last_name[0]}',
                                   style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                             ),
                           ],
                         ),
                         ),
                         Expanded(
                           flex: 2,
                           child: Row(
                           children: [
                             Text('${data.first_name} ${data.last_name}',
                                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                             ),
                           ],
                         ),
                         ),
                       ],
                     )
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                      Text('Phone Numbers: ', style: TextStyle(fontWeight: FontWeight.w500)),
                      phoneNumbersList(index)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: widget.dataList.isEmpty ? NoContact() : Container(
        child: new ListView.builder(
            itemCount: widget.dataList.length,
            itemBuilder: (BuildContext context, int index) => buildDataCard(context, index)),
      ),
    );
  }
}

