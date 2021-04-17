import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:students_list/Models/student.dart';
import 'package:students_list/Screens/student_detail.dart';
import 'package:students_list/utilities/sql_helper.dart';
class StudentsList extends StatefulWidget {
  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  SQL_Helper helper = new SQL_Helper();
  List<Student> studentsList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (studentsList == null) {
      studentsList = new List<Student>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: getStudentsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // debugPrint('Floating has been clicked');
          navigateToStudent(Student('', '', 1, ''), 'Add New Student');
          updateListView();
        },
        tooltip: 'Add Student',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getStudentsList() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isPased(this.studentsList[position].pass),
                child: getIcon(this.studentsList[position].pass),
              ),
              title: Text(this.studentsList[position].name),
              subtitle: Text(this.studentsList[position].description + "|" +
                  this.studentsList[position].date),
              trailing:
              GestureDetector(child: Icon(Icons.delete, color: Colors.grey,),
                onTap: () {
                _delete(context, this.studentsList[position]);
                },
              ),
              onTap: () {
                //debugPrint('Student Tabed');
                navigateToStudent(this.studentsList[position],'Edit Content');
              },
            ),
          );
        });
  }

  Color isPased(int value) {
    switch (value) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.amber;
    }
  }

  Icon getIcon(int value) {
    switch (value) {
      case 1:
        return Icon(Icons.check);
      case 2:
        return Icon(Icons.close);
      default:
        return Icon(Icons.check);
    }
  }

  void _delete(BuildContext context ,Student student)async{
    int result =await helper.deleteStudent(student.id);
    if(result!=0){
      _showSnackBar(context,"Has been Deleted");
      //Update ListView
    }
  }

  void _showSnackBar(BuildContext context,String msg){
    final snackBar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackBar);
  }
  void updateListView(){
    final Future<Database> db =helper.initializedDatabase();
    db.then((database) {
     Future<List<Student>> students = helper.getStudentList();
     students.then((theList) {
       this.studentsList=theList;
       this.count=theList.length;
     });
    });
  }
  void navigateToStudent(Student student ,String appTitle) async{
   bool result=await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StudentDetail(student , appTitle);
    }));
   if(result){
     updateListView();
   }
  }
}