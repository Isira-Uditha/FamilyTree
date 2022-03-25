import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/member.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('family');

class History {
  final String? historyID;
  final String topic;
  final String historyDate;
  final String historyImage;
  final List<Member> members;
  final String description;

  const History({
    this.historyID,
    required this.topic,
    required this.historyDate,
    required this.historyImage,
    required this.members,
    required this.description,
  });


  static Future<void> addHistory(History history) async {
    DocumentReference documentReference =
    _mainCollection.doc('1').collection('history').doc();

    var members = <dynamic, dynamic>{};

    for (var element in history.members) {
      members.addAll({element.docId: element.name});
    }

    Map<String, dynamic> data = <String, dynamic>{
      "topic": history.topic,
      "historyDate": history.historyDate,
      "historyImage": history.historyImage,
      "members": members,
      "description": history.description,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("History inserted to the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readHistory() {
    CollectionReference historyCollection =
    _mainCollection.doc('1').collection('history');
    return historyCollection.snapshots();
  }

  static Future<void> updateHistory(History history) async {
    DocumentReference documentReference =
    _mainCollection.doc('1').collection('history').doc(history.historyID);

    var members = <dynamic, dynamic>{};

    for (var element in history.members) {
      members.addAll({element.docId: element.name});
    }

    Map<String, dynamic> data = <String, dynamic>{
      "topic": history.topic,
      "historyDate": history.historyDate,
      "historyImage": history.historyImage,
      "members": members,
      "description": history.description,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("History updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteHistory({
    required String historyID,
  }) async {
    DocumentReference documentReference =
    _mainCollection.doc('1').collection('history').doc(historyID);

    await documentReference
        .delete()
        .whenComplete(() => print("History deleted from the database"))
        .catchError((e) => print(e));
  }
}
