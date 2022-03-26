import 'package:family_tree/Model/event.dart';
import 'package:family_tree/components/event/edit_event_form.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatefulWidget {
  final String currentDocId;
  final String eventName;
  final String date;
  final String time;
  final String location;
  final String description;

  const EditEventScreen({
    Key? key,
    required this.currentDocId,
    required this.eventName,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
  }) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
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
          title: const Text(
            "Edit Event",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: EditEventForm(
                    eventNameFocusNode: _eventNameFocusNode,
                    dateFocusNode: _dateFocusNode,
                    timeFocusNode: _timeFocusNode,
                    locationFocusNode: _locationFocusNode,
                    descriptionFocusNode: _descriptionFocusNode,
                    event: Event(
                      docId: widget.currentDocId,
                      name: widget.eventName,
                      date: widget.date,
                      time: widget.time,
                      location: widget.location,
                      description: widget.description,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
