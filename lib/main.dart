import 'package:flutter/material.dart';
import 'Screens/student_detail.dart';
import 'Screens/student_list.dart';
import 'dart:async';
void main() {
  runApp(MyApp());
}
  /*print('Strat app');
  getFileContent();
  print('End app');
getFileContent()async{
  String filecontent = await downloadFile();
}   */
  getFileContent(){
    Future<String> filecontent =downloadFile();
    filecontent.then((result) {
      print(result);
    });
  }
Future<String> downloadFile (){
  Future<String> content =Future.delayed(Duration(seconds: 60),(){
    return "Internet File Content";
  });
  return content;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students List ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: StudentsList(),
    );
  }
}




