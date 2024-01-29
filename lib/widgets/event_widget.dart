import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:image_picker/image_picker.dart';

class EventWidget extends StatefulWidget {
  final Function(EventInfo) addEvent;

  const EventWidget({required this.addEvent, super.key});

  @override
  EventWidgetState createState() => EventWidgetState();
}
String pictureUrl='';
class EventWidgetState extends State<EventWidget> {
  final TextEditingController eventController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController pictureUrlController = TextEditingController();
  final TextEditingController clubController=TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
        _pickImage();
        selectedDate = datePicked;
      });
    }
  }
  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      pictureUrl = pickedFile.path;
    });
  }
}

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (timePicked != null && timePicked != selectedTime) {
      setState(() {
        selectedTime = timePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //color: Colors.blueGrey[100], // Change background color
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add event details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: clubController,
              decoration: InputDecoration(
                labelText: 'Club Name',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: eventController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.blue),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Change button color
                  ),
                  child: const Text('Select Date'),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time: ${selectedTime.format(context)}',
                  style: TextStyle(color: Colors.blue),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Change button color
                  ),
                  onPressed: () => _selectTime(context),
                  child: const Text('Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          TextField(
            controller: locationController, // Add a TextEditingController for location
            decoration: InputDecoration(
              labelText: 'Location',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          TextField(
            controller: minAgeController, // Add a TextEditingController for location
            decoration: InputDecoration(
              labelText: 'Minimum visitors age',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Change button color
          ),
          onPressed: () => _pickImage(),
          child: const Text('Pick Image'),
        ),

            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Change button color
              ),
              onPressed: () {
                DateTime selectedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                EventInfo event = EventInfo(
                  clubName: clubController.text,
                  eventName: eventController.text,
                  location: locationController.text,
                  dateTime: selectedDateTime,
                  minAge: int.tryParse(minAgeController.text) ?? 0,
                  pictureUrl: pictureUrlController.text,
                );
                widget.addEvent(event);
                Navigator.pop(context);
              },
              child: const Text('Add an event'),
            ),
          ],
        ),
      ),
    );
  }
}