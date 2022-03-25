import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('family');

class Event {
  final String? docId;
  final String name;
  final String date;
  final String place;
  final String description;

  const Event(
      {this.docId,
      required this.name,
      required this.date,
      required this.place,
      required this.description});

  static Future<void> addEvent(Event event) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('event').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": event.name,
      "date": event.date,
      "place": event.place,
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

  static Future<void> updateEvent(Event event) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('event').doc(event.docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": event.name,
      "date": event.date,
      "place": event.place,
      "description": event.description,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Event update success"))
        .catchError((e) => print(e));
  }
}
