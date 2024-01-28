import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  const MessageTextField({
    Key? key,
    required this.currentId,
    required this.friendId,
  }) : super(key: key);

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  Position? _currentPosition;
  String? _currentAddress;
  String? message;
  File? imagefile;
  LocationPermission? permission;

  Future getImage() async {
    final _picker = ImagePicker();
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      imagefile = File(xFile.path);
      uploadImage();
    }
  }

  Future getImageFromCamera() async {
    final _picker = ImagePicker();
    final xFile = await _picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      imagefile = File(xFile.path);
      uploadImage();
    }
  }

  Future uploadImage() async {
    try {
      final fileName = Uuid().v1();
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child("$fileName.jpg");
      final uploadTask = await ref.putFile(imagefile!);

      if (uploadTask.state == TaskState.success) {
        final imageUrl = await ref.getDownloadURL();
        sendMessage(imageUrl, 'img');
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future _getCurrentLocation() async {
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          Fluttertoast.showToast(msg: "Location permission permanently denied");
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );

      setState(() {
        _currentPosition = position;
        _getAddressFromLatLon();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error getting location: $e");
    }
  }

  _getAddressFromLatLon() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      final place = placemarks.first;
      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error getting address: $e");
    }
  }

  sendMessage(String message, String type) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentId)
          .collection('messages')
          .doc(widget.friendId)
          .collection('chats')
          .add({
        'senderId': widget.currentId,
        'receiverId': widget.friendId,
        'message': message,
        'type': type,
        'date': DateTime.now(),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.friendId)
          .collection('messages')
          .doc(widget.currentId)
          .collection('chats')
          .add({
        'senderId': widget.currentId,
        'receiverId': widget.friendId,
        'message': message,
        'type': type,
        'date': DateTime.now(),
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: Colors.pink,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type your message',
                  fillColor: Colors.grey[100],
                  filled: true,
                  prefixIcon: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => bottomSheet(),
                      );
                    },
                    icon: Icon(Icons.add_box_rounded, color: Colors.blue),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  message = _controller.text;
                  sendMessage(message!, 'text');
                  _controller.clear();
                },
                child: Icon(
                  Icons.send,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            chatsIcon(
              Icons.location_pin,
              "Location",
              () async {
                await _getCurrentLocation();
                Future.delayed(Duration(seconds: 2), () {
                  message =
                      "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}";

                  sendMessage(message!, "link");
                });
              },
            ),
            chatsIcon(
              Icons.camera_alt,
              "Camera",
              () async {
                await getImageFromCamera();
              },
            ),
            chatsIcon(
              Icons.insert_photo,
              "Photo",
              () async {
                await getImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget chatsIcon(IconData icons, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(icons),
          ),
          Text("$title")
        ],
      ),
    );
  }
}
