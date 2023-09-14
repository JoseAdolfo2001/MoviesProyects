import 'dart:convert';

import 'package:flutter/material.dart';

class HelloWord extends StatelessWidget {
  const HelloWord({super.key});
 

  @override
  Widget build(BuildContext context) {
    String user = "";
    String passWord = "";
    Map<String , String> map = {};
    return Scaffold(
      appBar: AppBar(
        title: Text("HOLA") ,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 500,
        color: Colors.red,
        child:Column(
          children:  [
            const Text(
              "hola"
            ),
            TextFormField(
              onChanged: (String value){
                 user = value;
              },
            ),
            TextFormField(
              onChanged: (String value){
                passWord = value;
              },
            ),
            ElevatedButton(
              onPressed: (){
                map["user"] = user;
                map["password"] = passWord;
                final mapToJson = jsonEncode(map);
                print(mapToJson);
              }, 
              child: const Text("Save"))
          ],
        )
    
      ),
    );
  }
}