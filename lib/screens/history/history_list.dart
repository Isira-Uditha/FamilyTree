import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/history/list_view_history.dart';
import 'package:family_tree/screens/history/add_history.dart';
import 'package:flutter/material.dart';

import '../../components/family/list_view.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Member> members = [];
    var list = Member.readMembers();

    list.forEach((element) {
      for (var element in element.docs) {
        String docId = element.id;
        String name = element['name'];
        String age = element['age'];
        String dob = element['dob'];
        String relationship = element['relationship'];
        String description = element['description'];

        Member familyMember = Member(
            docId: docId,
            name: name,
            dob: dob,
            age: age,
            relationship: relationship,
            description: description);
        members.add(familyMember);
      }
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: double.infinity),
              child: Icon(
                Icons.add,
                size: 30.0,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddHistoryScreen(allMembers: members),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          'History List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: HistoryListView(),
    );
  }
}
