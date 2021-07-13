import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contactModel.dart';
import 'createNewContactScreen.dart';
import 'updateContacts.dart';


Future<ContactModel> deleteContactData(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://phonebookappapicloud.herokuapp.com/contacts/delete/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return ContactModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete contact.');
  }
}

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  List<Future<ContactModel>> futureContactData = <Future<ContactModel>>[];
  int contactsCount = 0;
  late Future<ContactModel> _dataModel;

  @override
  void initState(){
    super.initState();
    getContactData();
  }

  //get Contacts from DB
  Future getContactData() async{
    final response = await http.get(Uri.http('phonebookappapicloud.herokuapp.com', 'contacts'));
    final jsonData = jsonDecode(response.body);
    List<ContactModel> contactmodels = [];

    for (var u in jsonData){
      ContactModel data = ContactModel(phoneNumbers: u["phone_numbers"], id: u["_id"], lastName: u["last_name"], firstName: u["first_name"], v: u["__v"]);
      contactmodels.add(data);
    }

    if(response.statusCode == 200){
      print("Contact data taken from Database");
      print("Total contacts: ${contactmodels.length} ");
      return contactmodels;
    }else{
      print("Cannot get data");
    }
  }

  Widget phoneNumbersList(AsyncSnapshot<dynamic> snapshot,int index){
    return new Container(
      child: Column(
        children: snapshot.data[index].phoneNumbers.map<Widget>((x) => Text(x, style: TextStyle(fontWeight: FontWeight.w500),)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Contact Lists", style: TextStyle(fontSize: 22),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewContact()));
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeleteContactAndRefreshScreen()));
            },
            child: Icon(Icons.person_add_alt, color: Colors.black),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh list',
            onPressed: () {
              setState(() {
                getContactData();
              });
            },
          ),
        ],
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
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(snapshot.data[index].id),
                          onDismissed: (direction) {
                            String contactName = (snapshot.data[index].firstName.toString() + ' ' + snapshot.data[index].lastName.toString());
                            deleteContactData(snapshot.data[index].id);
                            setState(() {
                              snapshot.data.removeAt(index);
                            });
                            // Then show a snackbar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Contact: $contactName deleted')));
                          },
                          //confirmation
                          confirmDismiss: (DismissDirection direction) async{
                            return await showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete?"),
                                //content: const Text('Delete contact?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop(true);
                                        setState(() {
                                          getContactData();
                                        });
                                      },
                                      child: const Text('Delete'))
                                ],
                              );
                            });
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                              child: Icon(Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateContactPage(id: snapshot.data[index].id.toString())));
                            },
                            child: Card(
                              margin: EdgeInsets.only(top: 10),
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
                                                      TextButton(
                                                        onPressed: (){
                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateContactPage(id: snapshot.data[index].id.toString())));
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                                          radius: 25.0,
                                                          child: Text(snapshot.data[index].firstName[0] + snapshot.data[index].lastName[0],
                                                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: [
                                                      Text(snapshot.data[index].firstName + ' ' + snapshot.data[index].lastName,
                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
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