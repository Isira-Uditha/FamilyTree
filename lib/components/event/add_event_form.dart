import 'package:family_tree/Model/event.dart';
import 'package:family_tree/providers/event_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../../Model/member.dart';

class AddEventForm extends StatefulWidget {
  final FocusNode eventNameFocusNode;
  final FocusNode dateFocusNode;
  final FocusNode timeFocusNode;
  final FocusNode locationFocusNode;
  final FocusNode descriptionFocusNode;
  final List<Member> allParticipants;

  const AddEventForm({
    Key? key,
    required this.eventNameFocusNode,
    required this.dateFocusNode,
    required this.timeFocusNode,
    required this.locationFocusNode,
    required this.descriptionFocusNode,
    required this.allParticipants,
  }) : super(key: key);

  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _addEventFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  TimeOfDay currentTime = TimeOfDay.now();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String getEventName = "";
  String getDate = "";
  String getTime = "";
  String getLocation = "";
  String getDescription = "";
  List<Member> getParticipants = [];

  List<Member> _selectedParticipants = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _addEventFormKey,
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
                controller: _nameController,
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
                title: const Text("Participants"),
                selectedColor: Colors.blue,
                searchable: true,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Participants cannot be empty";
                  }
                },
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
                    color: Colors.black54,
                  ),
                ),
                onConfirm: (results) {
                  _selectedParticipants = results.cast<Member>();
                  setState(() {
                    _selectedParticipants = _selectedParticipants;
                  });
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
              _selectedParticipants.isEmpty
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

                    if (_addEventFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });

                      Event event = Event(
                          name: getEventName,
                          date: getDate,
                          time: getTime,
                          participants: getParticipants,
                          location: getLocation,
                          description: getDescription);
                      await Event.addEvent(event);

                      setState(() {
                        _isProcessing = false;
                        Provider.of<EventProvider>(context, listen: false)
                            .alert(
                                title: 'Successfully Added',
                                body: 'Event has been successfully added',
                                context: context);
                      });
                    } else {
                      print(0);
                    }
                  },
                  style: ElevatedButton.styleFrom(maximumSize: Size.infinite),
                  child: (!_isProcessing)
                      ? Text("Save")
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
