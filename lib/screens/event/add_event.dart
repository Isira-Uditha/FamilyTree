import 'package:family_tree/Model/member.dart';
import 'package:family_tree/components/event/add_event_form.dart';
import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';

class AddEventScreen extends StatelessWidget {
  final List<Member> allParticipants;

  AddEventScreen({
    Key? key,
    required this.allParticipants,
  }) : super(key: key);

  final FocusNode _eventNameFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _timeFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        _eventNameFocusNode.unfocus(),
        _dateFocusNode.unfocus(),
        _timeFocusNode.unfocus(),
        _locationFocusNode.unfocus(),
        _descriptionFocusNode.unfocus(),
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          title: const Text(
            'Add Event',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AssetGiffDialog(
                          onlyOkButton: true,
                          onOkButtonPressed: () {
                            Navigator.pop(context);
                          },
                          buttonOkText: const Text("Got it!",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          buttonOkColor: Colors.blueAccent,
                          image: Image.asset(
                            'assets/generation/genZ.gif',
                            fit: BoxFit.fill,
                          ),
                          title: const Text(
                            "Adding an Upcoming Event",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: const Text(
                            "Event Name, Date, Time, Participants and Location must be there in order to add an upcoming event",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ));
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: double.infinity),
                child: Icon(
                  Icons.help,
                  size: 30.0,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: AddEventForm(
                eventNameFocusNode: _eventNameFocusNode,
                dateFocusNode: _dateFocusNode,
                timeFocusNode: _timeFocusNode,
                descriptionFocusNode: _descriptionFocusNode,
                locationFocusNode: _locationFocusNode,
                allParticipants: allParticipants,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
