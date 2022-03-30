import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/history.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:family_tree/screens/history/edit_history.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  bool _isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: History.readHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var history =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String historyID = snapshot.data!.docs[index].id;
                String topic = history['topic'];
                String historyDate = history['historyDate'];
                String image = history['image'] ?? "";
                String description = history['description'];
                final memberList = history['members'] as Map<dynamic, dynamic>;

                final List<Member> members = [];
                final List<Member> currentMembers = [];

                var list = Member.readMembers();
                list.forEach((element) {
                  for (var element in element.docs) {
                    String docId = element.id;
                    String name = element['name'];
                    String age = element['age'];
                    String dob = element['dob'];
                    String relationship = element['relationship'];
                    String description = element['description'];
                    String image = element['image'] ?? "";

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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditHistoryScreen(
                              currenthistoryID: historyID,
                              currenttopic: topic,
                              currenthistoryDate: historyDate,
                              currentImage: image,
                              currentMembers: currentMembers,
                              currentDescription: description,
                              allMembers: members),
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
                            child: Text(topic),
                          ),
                          subtitle: Text(historyDate),
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
                                          "This action cannot be undone. Your selected history record will be removed permanently.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        entryAnimation: EntryAnimation.top,
                                        buttonCancelColor: Colors.black12,
                                        buttonOkColor: Colors.blueAccent,
                                        onOkButtonPressed: () async {
                                          await History.deleteHistory(historyID: historyID);
                                          setState(() {
                                            _isDeleted = false;
                                            Navigator.pop(context);
                                            Provider.of<MemberProvider>(context,
                                                listen: false)
                                                .alert(
                                                title: 'Successfully Deleted',
                                                body:
                                                'Record has been successfully deleted',
                                                context: context);
                                          });
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
