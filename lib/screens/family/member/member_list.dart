import 'package:family_tree/components/family/list_view.dart';
import 'package:family_tree/screens/family/family_tree.dart';
import 'package:family_tree/screens/family/member/add_member.dart';
import 'package:flutter/material.dart';

class MemberList extends StatelessWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Family(),
            ),
          ),
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
                  builder: (context) => AddMemberScreen(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          'Member List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const MemberListView(),
    );
  }
}
