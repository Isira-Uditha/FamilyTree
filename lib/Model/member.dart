import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('family');

class Member {
  final String? docId;
  final String name;
  final String dob;
  final String age;
  final String relationship;
  final String description;
  final String image;

  const Member({
    this.docId,
    required this.name,
    required this.dob,
    required this.age,
    required this.relationship,
    required this.description,
    required this.image,
  });


  static Future<void> addMember(Member member) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('member').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": member.name,
      "dob": member.dob,
      "age": member.age,
      "relationship": member.relationship,
      "description": member.description,
      "image": member.image
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Note member inserted to the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readMembers() {
    CollectionReference memberCollection =
        _mainCollection.doc('1').collection('member');
    return memberCollection.snapshots();
  }

  static Future<void> updateMember(Member member) async {
    DocumentReference documentReference =
    _mainCollection.doc('1').collection('member').doc(member.docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": member.name,
      "dob": member.dob,
      "age": member.age,
      "relationship": member.relationship,
      "description": member.description,
      "image": member.image,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Note member updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteMember({
    required String docId,
  }) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('member').doc(docId);

    await documentReference
        .delete()
        .whenComplete(() => print("Note member deleted from the database"))
        .catchError((e) => print(e));
  }
}
