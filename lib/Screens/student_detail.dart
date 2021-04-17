import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:students_list/Models/student.dart';
import 'package:students_list/utilities/sql_helper.dart';
import 'dart:async';
//import 'package:students_list/Screens/student_list.dart';


class StudentDetail extends StatefulWidget {
  String screentitle;
  Student student;
  StudentDetail(this.student ,this.screentitle);
  @override
  Students createState() => Students(this.student ,this.screentitle);
}

class Students extends State<StudentDetail> {
  String screentitle;
  Student student;
  Students (this.student ,this.screentitle);
  SQL_Helper helper =new SQL_Helper();
  static var _status =['successed','failed'];
  TextEditingController studentName =new TextEditingController();
  TextEditingController studentDetail=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextStyle textstyle = Theme.of(context).textTheme.title;
    studentName.text =student.name;
    studentDetail.text=student.description;
    return 
      WillPopScope(
        onWillPop:(){
          goBack();
          },
        child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Student'),
             leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed:(){
                 goBack();
                }
            )
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0,left:10.0,right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
              items: _status.map((String dropDownItem){
        return DropdownMenuItem<String>(
        value: dropDownItem,
        child: Text(dropDownItem),
        );
        }).toList(),
                  style: textstyle,
                  value:getPassing(student.pass),
                  onChanged: (selectedItem){
                setState(() {
                 setPassing(selectedItem);
                });
                  },
    ),
    ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0,bottom: 15.0),
    child: TextField(
    controller: studentName,
    style: textstyle,
    onChanged: (value){
        student.description=value;
    },
        decoration: InputDecoration(
          labelText: 'Name : ',
          labelStyle: textstyle ,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          )
        ),
    ),
    ),
              Padding(
                padding: EdgeInsets.only(left: 15.0,bottom: 15.0),
                child: TextField(
                  controller: studentDetail,
                  style: textstyle,
                  onChanged: (value){
                    debugPrint('User Edit the Description ');
                  },
                  decoration: InputDecoration(
                      labelText: 'Description : ',
                      labelStyle: textstyle ,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'SAVE',textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                           debugPrint("User Click SAVED");
                           _save();
                        });
                      },
                    )
                    ),
                    Container(width: 5,),
                    Expanded(child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delate',textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint("User Click Delate");
                          _delete();
                        });
                      },
                    )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    ),
      );
  }
  void goBack(){
    Navigator.pop(context,true);
  }
  void setPassing (String Value){
    switch(Value){
      case 'successed':
        student.pass=1;
        break;
      case 'failed':
        student.pass=2;
        break;
    }
  }
  String getPassing (int value){
    String pass;
    switch(value){
      case 1:
        pass=_status[0];
        break;
      case 2:
        pass=_status[1];
        break;
    }
    return pass;
  }
  void _save ()async{
   // goBack();
    //student.date=DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(student.id!=null){
      result =await helper.insertStudent(student);
    }else{
      result =await helper.updateStudent(student);
    }
    if(result==0){
      showAlertDialog('Sorry', 'Student not saved');
  }else{
      showAlertDialog('Congratulations', 'Student has been saved sucessfully');
    }
    }
    void showAlertDialog(String title,String msg){
    AlertDialog alertDialog =AlertDialog(
        title:Text('title'),
        content:Text(msg),
    );
    showDialog(context:context, builder:(_)=>alertDialog);
    }
    void _delete()async{
    goBack();
    if(student.id==null){
      showAlertDialog('Ok Deleted', 'No Student was deleted');
      return;
    }
    int result =await helper.deleteStudent(student.id);
    if(result==0){
      showAlertDialog('Ok Deleted', 'No Student was deleted');
    }else
      showAlertDialog('Ok Deleted', 'Student has been  deleted');
    }
    }