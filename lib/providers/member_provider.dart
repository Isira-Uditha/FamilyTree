import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/screens/family/member/member_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberProvider extends ChangeNotifier {
  Set<Member> _members = {};
  Set<Member> get member => _members;

  void addMember(Member member) async {
    await Member.addMember(member);
    notifyListeners();

  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int currentMonth = currentDate.month;
    int birthMonth = birthDate.month;

    if (birthMonth > currentMonth) {
      age--;
    } else if (currentMonth == birthMonth) {
      int currentDay = currentDate.day;
      int birthDay = birthDate.day;
      if (birthDay > currentDay) {
        age--;
      }
    }
    return age;
  }

  InputDecoration inputDecoration({String? pIcon}) {
    return InputDecoration(
      labelStyle: const TextStyle(color: Colors.yellowAccent),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: (pIcon) != null ? Icon(Icons.date_range_rounded) : null,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          )),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
          )),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          )),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
    );
  }

  readMembers() async {
    return Member.readMembers();
  }

  alert({required String title,required String body, required BuildContext context}){
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${title}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('${body}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if(title == 'Successfully Deleted'){
                    Navigator.pop(context);
                  }else{
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  }
                },
              ),
            ],
          );
        }
    );
  }

}
