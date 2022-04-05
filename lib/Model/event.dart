import 'package:cloud_firestore/cloud_firestore.dart';

import 'member.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('family');

class Event {
  final String? docId;
  final String name;
  final String date;
  final String time;
  final List<Member> participants;
  final String location;
  final String description;

  const Event(
      {this.docId,
      required this.name,
      required this.date,
      required this.time,
      required this.participants,
      required this.location,
      required this.description});

  // Function refers to adding new Event to the databse
  static Future<void> addEvent(Event event) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('event').doc();

    var participants = <dynamic, dynamic>{};

    for(var element in event.participants) {
      participants.addAll({element.docId: element.name});
    }

    Map<String, dynamic> data = <String, dynamic>{
      "name": event.name,
      "date": event.date,
      "time": event.time,
      "participants": participants,
      "location": event.location,
      "description": event.description,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Event inserted to firestore"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readEvents() {
    CollectionReference eventCollection =
        _mainCollection.doc('1').collection('event');
    return eventCollection.snapshots();
  }

  // Function refers to delete selected Event from the database
  static Future<void> deleteEvent({
    required String docId,
  }) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('event').doc(docId);

    await documentReference
        .delete()
        .whenComplete(() => print("Event has deleted from firestore"))
        .catchError((e) => print(e));
  }

  // Function refers to update the selected Event
  static Future<void> updateEvent(Event event) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('event').doc(event.docId);

    var participants = <dynamic, dynamic>{};

    for(var element in event.participants) {
      participants.addAll({element.docId: element.name});
    }

    Map<String, dynamic> data = <String, dynamic>{
      "name": event.name,
      "date": event.date,
      "time": event.time,
      "participants": participants,
      "location": event.location,
      "description": event.description,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Event update success"))
        .catchError((e) => print(e));
  }
}
