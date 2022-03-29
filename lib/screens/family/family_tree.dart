import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/family/storage.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:family_tree/screens/event/event_list_screen.dart';
import 'package:family_tree/screens/family/member/member_list.dart';
import 'package:family_tree/screens/family/member/pop_sibling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';

class Family extends StatefulWidget {
  const Family({Key? key}) : super(key: key);

  @override
  _FamilyState createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
  @override
  void initState() {
    final node1 = Node.Id(1);
    final node2 = Node.Id(2);
    final node3 = Node.Id(3);
    final node4 = Node.Id(4);
    final node5 = Node.Id(5);
    final node6 = Node.Id(6);
    final node7 = Node.Id(7);

    graph.addEdge(node1, node2);
    graph.addEdge(node1, node3);
    graph.addEdge(node2, node4);
    graph.addEdge(node2, node5);
    graph.addEdge(node3, node6);
    graph.addEdge(node3, node7);

    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (100)
      ..subtreeSeparation = (50)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m = const Image(
      height: 100,
      width: 100,
      image: AssetImage('assets/user.png'),
      fit: BoxFit.cover,
    );
    if (image != '') {
      await FireStorageService.loadFromStorage(context, image)
          .then((downloadUrl) {
        m = Image.network(
          downloadUrl.toString(),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
      });
    }

    return m;
  }

  @override
  Widget build(BuildContext context) {

    showSiblings(String type){
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return PopSiblingDetails(type: type);
        });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        title: const Text(
          'Family Tree',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        elevation: 10.0,
        child: Container(
          color: Colors.blue[400],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/blood line white.png"),
                      scale: 1.0,
                    ),
                  ),
                  child: SizedBox(),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    ListTile(
                      title: Row(children: const [
                        Icon(
                          Icons.dashboard_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white),
                        )
                      ]),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: const [
                          Icon(
                            Icons.people_alt,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          Text(
                            'Member',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MemberList(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: const [
                          Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          Text(
                            'History',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Row(
                        children: const [
                          Icon(
                            Icons.event,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          Text(
                            'Events',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EventListScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.more_horiz_sharp,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.blue[300],
            labelBackgroundColor: Colors.blue[300],
            child: Icon(Icons.person),
            label: 'My Siblings',
            elevation: 10,
            onTap: () => {
              showSiblings('My Siblings'),
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue[200],
            labelBackgroundColor: Colors.blue[200],
            child: Icon(Icons.people_alt),
            label: 'Father\'s Siblings',
            elevation: 10,
            onTap: () => {
              showSiblings('Father\'s Siblings'),
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue[100],
            labelBackgroundColor: Colors.blue[100],
            child: Icon(Icons.people_outline),
            label: 'Mother\'s Siblings',
            elevation: 10,
            onTap: () => {
              showSiblings('Mother\'s Siblings'),
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: EdgeInsets.all(50),
                  minScale: 0.01,
                  maxScale: 3.6,
                  child: GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(
                        builder, TreeEdgeRenderer(builder)),
                    paint: Paint()
                      ..color = Colors.greenAccent
                      ..strokeWidth = 8
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key?.value as int;

                      return StreamBuilder<QuerySnapshot>(
                          stream: Member.readByRelationship(getRelationship(a)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData || snapshot.data != null) {
                              String name = '';
                              String age = '';
                              String dob = '';
                              String relationship = '';
                              String description = '';
                              String image = '';
                              snapshot.data!.docs.forEach((element) {
                                name = element.get('name');
                                age = element.get('age');
                                dob = element.get('dob');
                                relationship = element.get('relationship');
                                description = element.get('description');
                                image = element.get('image');
                              });

                              Member newMember = Member(
                                  name: name,
                                  dob: dob,
                                  age: age,
                                  relationship: relationship,
                                  description: description,
                                  image: image);

                              return FutureBuilder(
                                  future: _getImage(context, image),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return rectangleWidget(
                                        a,
                                        getRelationship(a),
                                        snapshot.data as Widget,
                                        newMember,
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.orangeAccent),
                                        ),
                                      );
                                    }
                                  });
                            } else {
                              return const Text("Loading");
                            }
                          });
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Random r = Random();

  getRelationship(a) {
    if (a == 1) {
      return 'My Self';
    } else if (a == 2) {
      return 'Father';
    } else if (a == 3) {
      return 'Mother';
    } else if (a == 4) {
      return 'Paternal GrandFather';
    } else if (a == 5) {
      return 'Paternal GrandMother';
    } else if (a == 6) {
      return 'Maternal GrandFather';
    } else if (a == 7) {
      return 'Maternal GrandMother';
    }
  }

  Widget rectangleWidget(int a, relationship, Widget image, Member member) {
    return InkWell(
      onTap: () => {
        if(member.name != ''){
          Provider.of<MemberProvider>(
            context,
            listen: false,
          ).popMemberDetails(
              member: member, image: image, index: a, context: context),
        }

      },
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.blue,
                  child: ClipOval(
                    child: SizedBox(
                      width: 185.0,
                      height: 185.0,
                      child: image,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(relationship,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent)),
                const SizedBox(height: 10),
                Text(member.name,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                const SizedBox(height: 10),
                (member.age != '')
                    ? Text('Age : ${member.age}',
                        style: const TextStyle(
                            fontSize: 25, color: Colors.black45))
                    : const Text('Not Inserted Yet',
                        style: TextStyle(fontSize: 25)),
              ],
            ),
          )),
    );
  }

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
}
