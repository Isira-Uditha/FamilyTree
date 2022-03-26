import 'package:family_tree/components/event/add_event_form.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatelessWidget {
  AddEventScreen({Key? key}) : super(key: key);

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
              ))
            ],
          ),
        ),
      ),
    );
  }
}
