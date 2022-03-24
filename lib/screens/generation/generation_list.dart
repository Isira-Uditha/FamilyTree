import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/generation/list_view_generation.dart';
import 'package:family_tree/screens/generation/add_generation.dart';
import 'package:flutter/material.dart';

class GenerationList extends StatelessWidget {
  const GenerationList({Key? key}) : super(key: key);

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
        String image = element['image'];

        Member familyMember = Member(
            docId: docId,
            name: name,
            dob: dob,
            age: age,
            relationship: relationship,
            description: description,
            image: image
        );
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
                  builder: (context) =>
                      AddGenerationScreen(allMembers: members),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          'Generation List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const GenerationListView(),
    );
  }
}
