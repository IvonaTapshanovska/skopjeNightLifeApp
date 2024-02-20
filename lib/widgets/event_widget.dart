import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:camera/camera.dart';

class EventWidget extends StatefulWidget {
  final Function(EventInfo) addEvent;
  const EventWidget({required this.addEvent, super.key});

  @override
  EventWidgetState createState() => EventWidgetState();
}

class EventWidgetState extends State<EventWidget> {
  final TextEditingController eventController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController clubController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String pictureUrl = ''; 

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
       // _pickImage();
        selectedDate = datePicked;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pictureUrl = pickedFile.path;
      });

    }
  }

  Future<void> _takeImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        pictureUrl = pickedFile.path;
      });

    }
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance.ref().child(pictureUrl);

     
      await storageRef.putFile(imageFile);

     
      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return ''; 
    }
  }



  Future<void> _uploadImageAndAddEvent() async {
    final imageUrl = await _uploadImageToFirebaseStorage(File(pictureUrl));

    if (imageUrl.isNotEmpty) {
      DateTime selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

   
      final timestamp = Timestamp.fromDate(selectedDateTime);
      final event = EventInfo(
        clubName: clubController.text,
        eventName: eventController.text,
        location: locationController.text,
        dateTime: selectedDate.add(Duration(
          hours: selectedTime.hour,
          minutes: selectedTime.minute,
        )),
        minAge: int.tryParse(minAgeController.text) ?? 0,
        pictureUrl: imageUrl,
        lon: double.tryParse(lonController.text) ?? 0.0,
        lat: double.tryParse(latController.text) ?? 0.0,
      );
      EventInfo getEventInfo() => event;
      
      widget.addEvent(event);

      
      setState(() {
        clubController.clear();
        eventController.clear();
        locationController.clear();
        minAgeController.clear();
        pictureUrl = '';
        lonController.clear();
        latController.clear();
        
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
                  'Date: ${selectedDate.toLocal().toString().split(
                      ' ')[0]}',
                  style: TextStyle(color: Colors.blue),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
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
                    primary: Colors.blue,
                  ),
                  onPressed: () => _selectTime(context),
                  child: const Text('Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
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
            Container(height: 10),
            TextField(
              controller: lonController,
              decoration: InputDecoration(
                labelText: 'Lon...',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            Container(height: 10),
            TextField(
              controller: latController,
              decoration: InputDecoration(
                labelText: 'Lat...',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            Container(height: 10),
            TextField(
              controller: minAgeController,
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
                primary: Colors.blue,
              ),
              onPressed: () => _pickImage(),
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
              onPressed: () => _takeImage(),
              child: const Text('Take a Photo'),
            ),
            if (pictureUrl.isNotEmpty)
              Image.file(
                File(pictureUrl),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            else
              Text('No Image Selected'),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, 
              ),
              onPressed: () async {
                try {
                
                  await _uploadImageAndAddEvent();

                  
                  if (pictureUrl.isNotEmpty) {
                    DateTime selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final event = EventInfo(
                      clubName: clubController.text,
                      eventName: eventController.text,
                      location: locationController.text,
                      dateTime: selectedDateTime,
                      minAge: int.tryParse(minAgeController.text) ?? 0,
                      pictureUrl: pictureUrl,
                      lon: double.tryParse(lonController.text) ?? 0.0,
                      lat: double.tryParse(latController.text) ?? 0.0,
                    );

                  
                    await widget.addEvent(event);

                   
                    Navigator.pop(context);
                  } else {
                    
                    print('Image upload failed');
                  }
                } catch (e) {
                  
                  print('Error: $e');
                }
              },
              child: const Text('Add an event'),
            ),



          ],
        ),
      ),
    );
  }
}

