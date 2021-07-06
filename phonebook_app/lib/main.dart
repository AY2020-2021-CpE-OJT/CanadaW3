import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'contacts_list_with_API.dart';
import 'contactModel.dart';

void main() {
  runApp(FirstScreen());
}

class FirstScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task-003',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: NewContact(title: 'New Contact'),
    );
  }
}

class NewContact extends StatefulWidget {
  NewContact({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _NewContactState createState() => _NewContactState();
}

Future<ContactModel?> passData(String last_name, String first_name, List<dynamic> phone_numbers) async{
  final response = await http.post(Uri.http('192.168.1.6:5000', 'contacts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>
      {"last_name": last_name, "first_name": first_name, "phone_numbers": phone_numbers}));
  var cData = response.body;
  print(cData);

  if(response.statusCode == 201){
    return ContactModel.fromJson(jsonDecode(response.body));
  }else {
    print("Cannot save");
  }
}

class _NewContactState extends State<NewContact> {
  int numbersFieldCount = 1;
  final formKey = GlobalKey<FormState>();
  final fnController = TextEditingController();
  final lnController = TextEditingController();
  List<TextEditingController> numberController = <TextEditingController>[TextEditingController()];
  late Future<ContactModel?> _dataModel;

  @override
  void initState() {
    super.initState();
    fnController.addListener(() => setState(() {}));
    lnController.addListener(() => setState(() {}));
  }

  //Control multiple phone numbers
  void addNumberField() {
    setState(() {
      numberController.insert(0, TextEditingController()); //add data
      numbersFieldCount++; //increment
    });
  }
  void deleteNumberField() {
    setState(() {
      numbersFieldCount--;
    });
  }

  void nothingToSave(){
    final message = 'Nothing to save';
    final snackBar = SnackBar(
      content: Text(
        message, style:  TextStyle(fontSize: 15),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> saveNewContact() async {
    if (fnController.text.isEmpty && lnController.text.isEmpty){
      nothingToSave();
    }else{
      List<String> phoneNumbers = <String>[];
      //reverse since it acts as a stack
      for(int i = numbersFieldCount-1; i >= 0; i--){
        phoneNumbers.add(numberController[i].text);
        numberController[i].clear();
      }
      //ContactModel newData = await passData(lnController.text, fnController.text, phoneNumbers);

      setState(() {
        //_dataModel = newData;
        _dataModel = passData(lnController.text, fnController.text, phoneNumbers);
        numbersFieldCount = 1;
        FocusScope.of(context).requestFocus(FocusNode());
      });

      final message = 'Added to contacts';
      final snackBar = SnackBar(
          content: Text(
            message, style:  TextStyle(fontSize: 15),
          ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //reset contents
      fnController.clear();
      lnController.clear();
    }
  }

  //FIRST NAME
  Widget buildFirstName() => TextFormField(
    controller: fnController,
    decoration: InputDecoration(
      labelText: 'First Name',
      suffixIcon:fnController.text.isEmpty ?  Container(width: 0,): IconButton(
        icon: Icon(Icons.close),
        onPressed: () => fnController.clear(),
      ),
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.name,
    textInputAction: TextInputAction.done,
  );

  //LAST NAME
  Widget buildLastName() => TextFormField(
    controller: lnController,
    decoration: InputDecoration(
      labelText: 'Last Name',
      suffixIcon:lnController.text.isEmpty ?  Container(width: 0,): IconButton(
        icon: Icon(Icons.close),
        onPressed: () => lnController.clear(),
      ),
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.name,
    textInputAction: TextInputAction.done,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 24),),
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataFromAPI()));
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactsList(dataList: newData)));
           },
          child: Icon(Icons.contact_phone, color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            onPressed: (){
              saveNewContact();
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        //key: formKey,
        child: Column(
          children: [
            //Padding(padding: const EdgeInsets.only(bottom: 2.0)),
            Icon(Icons.account_box_rounded, size: 100.0),
            SizedBox(height: 10),
            buildFirstName(),
            SizedBox(height: 10),
            buildLastName(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Phone Numbers: ', style: TextStyle(fontSize: 16)),),
                SizedBox(width: 60),
                ButtonTheme(
                  minWidth: 50,
                  height: 30,
                    child: ElevatedButton(
                    child: Text('Add', style: TextStyle(fontSize: 15.0),),
                    onPressed: addNumberField))
              ],
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: numbersFieldCount, itemBuilder: (context, index){
                    return ListTile(
                      title: Row(
                        children: [
                          Flexible(
                            flex: 15,
                            child:
                           TextFormField(
                             controller: numberController[index],
                             decoration: InputDecoration(
                                border: OutlineInputBorder(),
                             ),
                             keyboardType: TextInputType.number,
                             textInputAction: TextInputAction.done,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              onPressed: deleteNumberField, icon: const Icon(Icons.close), splashRadius: 2),
                          ),
                        ],
                      ),
                    );
              }),
            ),
          ],
        ),
      ),
    );
  }
}