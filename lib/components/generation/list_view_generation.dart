import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/generation.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/Model/quality.dart';
import 'package:family_tree/providers/generation_provider.dart';
import 'package:family_tree/screens/generation/edit_generation.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:provider/provider.dart';

class GenerationListView extends StatefulWidget {
  const GenerationListView({Key? key}) : super(key: key);

  @override
  _GenerationListViewState createState() => _GenerationListViewState();
}

class _GenerationListViewState extends State<GenerationListView> {
  bool _isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Generation.readGenerations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var generation =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String docId = snapshot.data!.docs[index].id;
                String name = generation['name'];
                String description = generation['description'];
                String type = generation['type'];
                final memberList =
                    generation['members'] as Map<dynamic, dynamic>;
                final strengthsList =
                    generation["strengths"] as Map<dynamic, dynamic>;
                final weaknessesList =
                    generation["weaknesses"] as Map<dynamic, dynamic>;

                final List<Member> members = [];
                final List<Member> currentMembers = [];
                final List<Strength> currentStrengths = [];
                final List<Weaknesses> currentWeaknesses = [];

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
                    memberList.forEach((key, value) {
                      if (key == docId) {
                        currentMembers.add(familyMember);
                      }
                    });
                  }
                });

                strengthsList.forEach((key, value) {
                  currentStrengths.add(Strength(id: key, name: value));
                });

                weaknessesList.forEach((key, value) {
                  currentWeaknesses.add(Weaknesses(id: key, name: value));
                });

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditGenerationScreen(
                            currentDocId: docId,
                            currentName: name,
                            currentMembers: currentMembers,
                            currentStrengths: currentStrengths,
                            currentWeaknesses: currentWeaknesses,
                            currentDescription: description,
                            allMembers: members,
                            currentType: type,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: const Color.fromRGBO(255, 255, 255, 0.9),
                      child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(name),
                          ),
                          subtitle: Text(type),
                          trailing: _isDeleted
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.redAccent,
                                  ),
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
                                          await Generation.deleteGeneration(
                                              docId: docId);
                                          Navigator.pop(context);
                                          Provider.of<GenerationProvider>(
                                                  context,
                                                  listen: false)
                                              .alert(
                                                  title: 'Successfully Deleted',
                                                  body:
                                                      'Generation has been deleted successfully',
                                                  context: context);
                                        },
                                        onCancelButtonPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );

                                    setState(() {
                                      _isDeleted = false;
                                    });
                                  },
                                )),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          );
        });
  }
}
