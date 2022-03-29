import 'package:family_tree/Model/event.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/event/event_list.dart';
import 'package:family_tree/screens/event/add_event.dart';
import 'package:flutter/material.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Member> participants = [];
    final List<Event> events = [];
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
            age: age,
            dob: dob,
            relationship: relationship,
            description: description,
            image: image);
        participants.add(familyMember);
      }
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEventScreen(
                    allParticipants: participants,
                  ),
                ),
              )
            },
            icon: const Padding(
              padding: EdgeInsets.only(right: double.infinity),
              child: Icon(
                Icons.add,
                size: 30.0,
              ),
            ),
          )
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          'Event List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const EventList(),
    );
  }
}
