import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/screens/family/family_tree.dart';
import 'package:family_tree/screens/family/member/edit_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PopSiblingDetails extends StatefulWidget {
  final String type;

  const PopSiblingDetails({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _PopSiblingDetailsState createState() => _PopSiblingDetailsState();
}

class _PopSiblingDetailsState extends State<PopSiblingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        title: Text(
          widget.type,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Family(),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Member.readSiblings(widget.type),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
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
                  return SingleChildScrollView(
                    child: Padding(
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
                              padding:
                                  const EdgeInsets.only(top: 8, bottom: 15),
                              child: Text(name),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    flex: 1, child: Text('Birth Date :' + dob)),
                                Flexible(flex: 1, child: Text('Age:' + age)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                ),
              );
            }
          }),
    );
  }
}
