import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  List<Future<Data>> futureContactData = <Future<Data>>[];
  int contactsCount = 0;

  @override
  void initState(){
    super.initState();
  }

  //get Contacts from DB
  Future getContactData() async{
    var response = await http.get(Uri.http('192.168.1.6:5000', 'contacts'));
    var jsonData = jsonDecode(response.body);
    List<Data> list = [];

    for (var u in jsonData){
      Data data = Data(u["last_name"], u["first_name"], u["phone_numbers"]);
      list.add(data);
    }
    //show total contacts
    print("Total contacts: ${list.length} ");
    return list;
  }

  Widget phoneNumbersList(AsyncSnapshot<dynamic> snapshot,int index){
    return new Container(
      child: Column(
        children: snapshot.data[index].phone_numbers.map<Widget>((x) => Text(x, style: TextStyle(fontWeight: FontWeight.w500),)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Lists"),
      ),
      body: Center(
          child: Container(
            child: FutureBuilder(
              future: getContactData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                if(snapshot.data == null){
                  return Container(
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
                }else
                  return ListView.builder(itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return Card(
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
                                                  child: Text(snapshot.data[index].first_name[0] + snapshot.data[index].last_name[0],
                                                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Text(snapshot.data[index].first_name + ' ' + snapshot.data[index].last_name,
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
                                        phoneNumbersList(snapshot,index)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          )
      ),
    );
  }
}