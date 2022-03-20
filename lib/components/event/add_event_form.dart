import 'package:flutter/cupertino.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _addEventFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(height: 8.0,),
        ),
      ),
    );
  }
}
