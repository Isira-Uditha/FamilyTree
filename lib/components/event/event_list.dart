import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/event.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/screens/event/edit_event_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:provider/provider.dart';
import '../../providers/member_provider.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool _isDeleted = false;

  @override
  Widget build(BuildContext context) {
    final _today = DateTime.now();

    // Calculating the days between
    int daysBetween(DateTime fromDate, DateTime toDate) {
      fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
      toDate = DateTime(toDate.year, toDate.month, toDate.day);
      return (toDate.difference(fromDate).inHours / 24).round();
    }

    return StreamBuilder<QuerySnapshot>(
        stream: Event.readEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var event =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  String docId = snapshot.data!.docs[index].id;
                  String name = event['name'];
                  String date = event['date'];
                  String time = event['time'];
                  String location = event['location'];
                  String description = event['description'];
                  String year = event['date'].split("-")[0];
                  String month = event['date'].split("-")[1];
                  String day = event['date'].split("-")[2];
                  DateTime eventDate = DateTime(int.parse(year), int.parse(month), int.parse(day));
                  var difference = daysBetween(_today, eventDate);

                  //Skipping the minus remaining days
                  if(difference < 0) {
                    difference = 0;
                  }

                  final participantList =
                      event['participants'] as Map<dynamic, dynamic>;
                  final List<Member> members = [];
                  final List<Member> currentParticipants = [];
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
                          image: image);
                      members.add(familyMember);
                      participantList.forEach((key, value) {
                        if (key == docId) {
                          currentParticipants.add(familyMember);
                        }
                      });
                    }
                  });

                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditEventScreen(
                              currentDocId: docId,
                              eventName: name,
                              date: date,
                              time: time,
                              location: location,
                              description: description,
                              currentParticipants: currentParticipants,
                              allParticipants: members,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('${name}'),
                          ),
                          subtitle: Text('${difference} days for the event at ${location}'),
                          trailing: _isDeleted
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.redAccent),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    setState(() {
                                      _isDeleted = true;
                                    });

                                    showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffDialog(
                                        image: Image.asset(
                                          'assets/delete.gif',
                                          fit: BoxFit.fill,
                                        ),
                                        title: const Text(
                                          "Are you sure to delete?",
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        description: const Text(
                                          "This action cannot be undone. Your selected data will be removed permanently.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        entryAnimation: EntryAnimation.top,
                                        buttonCancelColor: Colors.black12,
                                        buttonOkColor: Colors.blueAccent,
                                        onOkButtonPressed: () async {
                                          await Event.deleteEvent(docId: docId);
                                          Navigator.pop(context);
                                          Provider.of<MemberProvider>(context,
                                                  listen: false)
                                              .alert(
                                                  title: 'Successfully Deleted',
                                                  body:
                                                      'Event has been deleted successfully',
                                                  context: context);
                                        },
                                        onCancelButtonPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );

                                    setState(
                                      () {
                                        _isDeleted = false;
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          );
        });
  }
}
