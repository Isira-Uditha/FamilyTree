import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:family_tree/screens/family/member/edit_member.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberListView extends StatefulWidget {
  const MemberListView({Key? key}) : super(key: key);

  @override
  _MemberListViewState createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  bool _isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Member.readMembers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var member =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String docId = snapshot.data!.docs[index].id;
                String name = member['name'];
                String age = member['age'];
                String dob = member['dob'];
                String relationship = member['relationship'];
                String description = member['description'];
                String image = member['image'] ?? "";

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditMemberScreen(
                            currentDocId: docId,
                            currentName: name,
                            currentDob: dob,
                            currentAge: age,
                            currentRelationship: relationship,
                            currentDescription: description,
                            currentImage: image,
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
                          subtitle: Text('${relationship}'),
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
                                    await Member.deleteMember(docId: docId);
                                    setState(() {
                                      _isDeleted = false;
                                      Provider.of<MemberProvider>(context,
                                              listen: false)
                                          .alert(
                                              title: 'Successfully Deleted',
                                              body:
                                                  'Record has been successfully deleted',
                                              context: context);
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
