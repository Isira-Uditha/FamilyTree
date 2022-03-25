import 'package:family_tree/Model/event.dart';
import 'package:family_tree/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventForm extends StatefulWidget {
  final FocusNode eventNameFocusNode;
  final FocusNode dateFocusNode;
  final FocusNode timeFocusNode;
  final FocusNode locationFocusNode;
  final FocusNode descriptionFocusNode;
  final Event event;

  const EditEventForm({
    Key? key,
    required this.eventNameFocusNode,
    required this.dateFocusNode,
    required this.timeFocusNode,
    required this.locationFocusNode,
    required this.descriptionFocusNode,
    required this.event,
  }) : super(key: key);

  @override
  _EditEventFormState createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {
  final _editEventFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  String getEventName = "";
  String getDate = "";
  String getTime = "";
  String getLocation = "";
  String getDescription = "";
  TimeOfDay currentTime = TimeOfDay.now();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _eventNameController.text = widget.event.name;
    _dateController.text = widget.event.date;
    _timeController.text = widget.event.time;
    _locationController.text = widget.event.location;
    _descriptionController.text = widget.event.description;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _editEventFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text(
                "Event Name",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<EventProvider>(context, listen: false)
                    .inputDecoration(),
                controller: _eventNameController,
                focusNode: widget.eventNameFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Event name cannot be empty.';
                  } else {
                    setState(() {
                      getEventName = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              Text(
                "Date",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<EventProvider>(context, listen: false)
                    .inputDecoration(pIcon: 'Date'),
                controller: _dateController,
                focusNode: widget.dateFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2023));
                  if (newDate == null) return;
                  setState(() {
                    getDate = DateFormat('yyyy-MM-dd').format(newDate);
                    _dateController.text = getDate;
                  });
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Date cannot be empty.';
                  } else {
                    setState(() {
                      getDate = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              Text(
                "Time",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<EventProvider>(context, listen: false)
                    .inputDecoration(pIcon: 'Time'),
                controller: _timeController,
                focusNode: widget.timeFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: currentTime,
                  );
                  if (newTime == null) return;
                  setState(() {
                    String hour = newTime.hour.toString().padLeft(2,'0');
                    String minute = newTime.minute.toString().padLeft(2, '0');
                    String time = '${hour}:${minute}';
                    _timeController.text = time;
                  });
                },
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Time cannot be empty.';
                  } else {
                    setState(() {
                      getTime = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              Text(
                "Location",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<EventProvider>(context, listen: false)
                    .inputDecoration(),
                controller: _locationController,
                focusNode: widget.locationFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Location cannot be empty.';
                  } else {
                    setState(() {
                      getLocation = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              Text(
                "Description",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: Provider.of<EventProvider>(context, listen: false)
                    .inputDecoration(),
                maxLines: 4,
                controller: _descriptionController,
                focusNode: widget.descriptionFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  setState(() {
                    getDescription = val.toString();
                  });
                },
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    widget.eventNameFocusNode.unfocus();
                    widget.dateFocusNode.unfocus();
                    widget.locationFocusNode.unfocus();
                    widget.descriptionFocusNode.unfocus();

                    if (_editEventFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });

                      Event event = Event(
                          docId: widget.event.docId,
                          name: getEventName,
                          date: getDate,
                          time: getTime,
                          location: getLocation,
                          description: getDescription);

                      await Event.updateEvent(event);

                      setState(() {
                        _isProcessing = false;
                        Provider.of<EventProvider>(context, listen: false)
                            .alert(
                                title: 'Successfully Updated',
                                body: 'Event has been successfully updated',
                                context: context);
                      });
                    } else {
                      print(0);
                    }
                  },
                  style: ElevatedButton.styleFrom(maximumSize: Size.infinite),
                  child: (!_isProcessing)
                      ? Text("Edit")
                      : const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
