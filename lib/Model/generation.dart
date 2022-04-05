import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/Model/quality.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('family');

class Generation {
  final String? docId;
  final String name;
  final String description;
  final String type;
  final List<Member> members;
  final List<Strength> strengths;
  final List<Weaknesses> weaknesses;

  const Generation({
    this.docId,
    required this.name,
    required this.description,
    required this.members,
    required this.strengths,
    required this.weaknesses,
    required this.type,
  });

  //Add a generation
  static Future<void> addGeneration(Generation generation) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('generation').doc();

    var members = <dynamic, dynamic>{};
    var strengths = <dynamic, dynamic>{};
    var weaknesses = <dynamic, dynamic>{};

    for (var element in generation.members) {
      members.addAll({element.docId: element.name});
    }

    for (var element in generation.strengths) {
      strengths.addAll({element.id: element.name});
    }

    for (var element in generation.weaknesses) {
      weaknesses.addAll({element.id: element.name});
    }

    Map<String, dynamic> data = <String, dynamic>{
      "name": generation.name,
      "description": generation.description,
      "members": members,
      "strengths": strengths,
      "weaknesses": weaknesses,
      "type": generation.type,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Note generation inserted to the database"))
        .catchError((e) => print(e));
  }

  //Read all generation records in the database
  static Stream<QuerySnapshot> readGenerations() {
    CollectionReference memberCollection =
        _mainCollection.doc('1').collection('generation');
    return memberCollection.snapshots();
  }

  //Delete a generation
  static Future<void> deleteGeneration({
    required String docId,
  }) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('generation').doc(docId);

    await documentReference
        .delete()
        .whenComplete(() => print("generation deleted from the database"))
        .catchError((e) => print(e));
  }

  //Update an existing generation
  static Future<void> updateGeneration(Generation generation) async {
    DocumentReference documentReference =
        _mainCollection.doc('1').collection('generation').doc(generation.docId);

    var members = <dynamic, dynamic>{};
    var strengths = <dynamic, dynamic>{};
    var weaknesses = <dynamic, dynamic>{};

    for (var element in generation.members) {
      members.addAll({element.docId: element.name});
    }

    for (var element in generation.strengths) {
      strengths.addAll({element.id: element.name});
    }

    for (var element in generation.weaknesses) {
      weaknesses.addAll({element.id: element.name});
    }

    Map<String, dynamic> data = <String, dynamic>{
      "name": generation.name,
      "description": generation.description,
      "members": members,
      "strengths": strengths,
      "weaknesses": weaknesses,
      "type": generation.type,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Note member updated in the database"))
        .catchError((e) => print(e));
  }

  //Find the standard generation type according to the selected members' birth years
  static GenerationType findGeneration(List<Member> members) {
    final List<dynamic> birthYears = [];
    final List<GenerationType> generationTypes = [];

    for (var element in members) {
      birthYears.add(int.parse(element.dob.substring(0, 4)));
    }

    for (var element in birthYears) {
      if (element >= 1946 && element <= 1964) {
        GenerationType.generationTypes.elementAt(0).count++;
      } else if (element >= 1965 && element <= 1976) {
        GenerationType.generationTypes.elementAt(1).count++;
      } else if (element >= 1977 && element <= 1994) {
        GenerationType.generationTypes.elementAt(2).count++;
      } else if (element >= 1995) {
        GenerationType.generationTypes.elementAt(3).count++;
      }
    }

    GenerationType generationType = GenerationType.generationTypes
        .reduce((curr, next) => curr.count > next.count ? curr : next);

    for (var element in GenerationType.generationTypes) {
      element.count = 0;
    }

    return generationType;
  }
}
