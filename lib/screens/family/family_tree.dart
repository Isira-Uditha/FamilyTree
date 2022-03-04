import 'package:family_tree/screens/family/member/member_list.dart';
import 'package:flutter/material.dart';

class Family extends StatefulWidget {
  const Family({Key? key}) : super(key: key);

  @override
  _FamilyState createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        title: const Text(
          'Family Tree',
          style: TextStyle(color: Colors.white),
        ),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Color.fromRGBO(28, 136, 231, 0.8),
                  fixedSize: Size(200, 100),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MemberList(),
                    ),
                  );
                },
                child: Text(
                  'Member',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
