import 'package:family_tree/Model/member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';

class MemberProvider extends ChangeNotifier {
  Set<Member> _members = {};

  Set<Member> get member => _members;

  //Reference to the https://viveky259259.medium.com/age-calculator-in-flutter-97853dc8486f,
  //this is required to calculate the age of the person by getting the date of birth as the input parameter
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

  //Input field decorations
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

  //Member - pop up window
  Future<void> popMemberDetails({
    required Member member,
    required Widget image,
    required int index,
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return NetworkGiffDialog(
          image: image,
          entryAnimation: EntryAnimation.topLeft,
          title: Text(
            member.relationship,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
          description: Text(
            'Name : ${member.name}\n\nAge : ${member.age}\n\nDate of Birth : ${member.dob}',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          ),
          onlyOkButton: true,
          onOkButtonPressed: () {
            Navigator.of(context).pop();
          },
          buttonOkColor: Colors.blue,
        );
      },
    );
  }

  alert({
    required String title,
    required String body,
    required BuildContext context,
  }) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
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
                  if (title == 'Successfully Deleted') {
                    Navigator.pop(context);
                  } else {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  }
                },
              ),
            ],
          );
        });
  }
}
