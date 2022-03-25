import 'package:family_tree/Model/event.dart';
import 'package:family_tree/providers/member_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEventForm extends StatefulWidget {
  final FocusNode eventNameFocusNode;
  final FocusNode dateFocusNode;
  final FocusNode placeFocusNode;
  final FocusNode descriptionFocusNode;

  const AddEventForm({
    Key? key,
    required this.eventNameFocusNode,
    required this.dateFocusNode,
    required this.placeFocusNode,
    required this.descriptionFocusNode,
  }) : super(key: key);

  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _addEventFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String getEventName = "";
  String getDate = "";
  String getPlace = "";
  String getDescription = "";

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
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Event Name",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
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
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Date",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(pIcon: 'Search'),
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
                  if(newDate == null) return;
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
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Location",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(),
                controller: _placeController,
                focusNode: widget.placeFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Location cannot be empty.';
                  } else {
                    setState(() {
                      getPlace = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Description",
                style: TextStyle(
                  color: Color.fromARGB(255, 22, 115, 177),
                  fontSize: 19.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                decoration: Provider.of<MemberProvider>(context, listen: false)
                    .inputDecoration(),
                controller: _descriptionController,
                focusNode: widget.descriptionFocusNode,
                onSaved: (String? val) {},
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val != null && val.isEmpty) {
                    return 'Description cannot be empty.';
                  } else {
                    setState(() {
                      getDescription = val.toString();
                    });
                  }
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    widget.eventNameFocusNode.unfocus();
                    widget.dateFocusNode.unfocus();
                    widget.placeFocusNode.unfocus();
                    widget.descriptionFocusNode.unfocus();

                    if (_addEventFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });

                      Event event = Event(
                          name: getEventName,
                          date: getDate,
                          place: getPlace,
                          description: getDescription);
                      await Event.addEvent(event);

                      setState(() {
                        _isProcessing = false;
                        Provider.of<MemberProvider>(context, listen: false)
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
