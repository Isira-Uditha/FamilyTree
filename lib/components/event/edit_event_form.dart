import 'package:family_tree/Model/event.dart';
import 'package:family_tree/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../../Model/member.dart';

class EditEventForm extends StatefulWidget {
  final FocusNode eventNameFocusNode;
  final FocusNode dateFocusNode;
  final FocusNode timeFocusNode;
  final FocusNode locationFocusNode;
  final FocusNode descriptionFocusNode;
  final List<Member> allParticipants;
  final Event event;

  const EditEventForm({
    Key? key,
    required this.eventNameFocusNode,
    required this.dateFocusNode,
    required this.timeFocusNode,
    required this.locationFocusNode,
    required this.descriptionFocusNode,
    required this.allParticipants,
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
  List<Member> getParticipants = [];
  TimeOfDay currentTime = TimeOfDay.now();


  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Member> _selectedParticipants = [];

  @override
  void initState() {
    super.initState();
    _eventNameController.text = widget.event.name;
    _dateController.text = widget.event.date;
    _timeController.text = widget.event.time;
    _locationController.text = widget.event.location;
    _descriptionController.text = widget.event.description;

    for (var participant in widget.allParticipants) {
      widget.event.participants.forEach((element) {
        if (element.docId == participant.docId) {
          _selectedParticipants.add(participant);
        }
      });
    }

    getParticipants = _selectedParticipants;
  }

  @override
  Widget build(BuildContext context) {
    String eventTime = widget.event.time;
    String hour = eventTime.split(":")[0];
    String minute = eventTime.split(":")[1];
    TimeOfDay currentTime = TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));

    return SingleChildScrollView(
      child: Form(
        key: _editEventFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const Text(
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
              const Text(
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
              const Text(
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
                    String hour = newTime.hour.toString().padLeft(2, '0');
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
              const Text(
                "Add Participants",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              MultiSelectDialogField(
                listType: MultiSelectListType.LIST,
                items: widget.allParticipants
                    .map((e) => MultiSelectItem(e, e.name))
                    .toList(),
                initialValue: _selectedParticipants,
                title: const Text("Participants"),
                selectedColor: Colors.blue,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Participants cannot be empty";
                  }
                },
                searchable: true,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    )),
                buttonIcon: const Icon(
                  Icons.family_restroom_rounded,
                  color: Colors.blue,
                ),
                buttonText: const Text(
                  "Select",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                onConfirm: (results) {
                  _selectedParticipants = results.cast<Member>();
                  setState(() {
                    _selectedParticipants = _selectedParticipants;
                  });
                  getParticipants = [];
                  getParticipants.addAll(_selectedParticipants);
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      _selectedParticipants.remove(value);
                    });
                  },
                ),
              ),
              getParticipants.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "None Selected",
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8.0),
              const Text(
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
              const Text(
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
                          participants: getParticipants,
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
                      ? const Text("Update")
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
