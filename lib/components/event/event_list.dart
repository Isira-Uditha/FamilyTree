import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/event.dart';
import 'package:flutter/material.dart';
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
                  String place = event['place'];
                  String description = event['description'];

                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                            subtitle: Text('${date}'),
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

                                      await Event.deleteEvent(docId: docId);
                                      setState(() {
                                        _isDeleted = false;
                                        Provider.of<MemberProvider>(context,
                                                listen: false)
                                            .alert(
                                                title: 'Successfully Deleted',
                                                body:
                                                    'Event has been deleted successfully',
                                                context: context);
                                      });
                                    },
                                  )),
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
