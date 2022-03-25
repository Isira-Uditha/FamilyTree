import 'package:family_tree/Model/event.dart';
import 'package:family_tree/components/event/event_list.dart';
import 'package:flutter/material.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Event> events = [];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Padding(
              padding: EdgeInsets.only(right: double.infinity),
              child: Icon(
                Icons.add,
                size: 30.0,
              ),
            ),
          )
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          'Event List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const EventList(),
    );
  }
}
