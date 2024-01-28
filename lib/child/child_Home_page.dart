


import 'dart:math';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sefty/Widges/Home_wedges/SafeHome/SafeHome.dart';
import 'package:sefty/Widges/Home_wedges/coustom_appBar.dart';
import 'package:sefty/Widges/Home_wedges/customcarouel.dart';
import 'package:sefty/Widges/LifeSafe.dart';
import 'package:sefty/db/db_services.dart';
import 'package:sefty/model/constactsm.dart';
import 'package:shake/shake.dart';

import '../Widges/Home_wedges/emergency.dart';

 class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 //const HomeScreen({super.key});
 int QIndex=0;
  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;

  String recipients = ""; // Initialize recipients as an empty string

  _getPermission() async {
    await [Permission.sms].request();
  }

  _isPermissionGranted() async => await Permission.sms.status.isGranted;

  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    try {
      final status = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber,
        message: message,
        simSlot: simSlot,
      );

      if (status == SmsStatus.sent) {
        Fluttertoast.showToast(msg: "Sent successfully");
      } else {
        Fluttertoast.showToast(msg: "Failed to send");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sending SMS: $e");
    }
  }


  _getCurrentLocation() async {
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          Fluttertoast.showToast(
              msg: "Location permission permanently denied");
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );

      setState(() {
        _currentPosition = position;
        print("Latitude: ${_currentPosition!.latitude}");
        _getAddressFromLatLon();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error getting location: $e");
    }
  }



  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error getting address: $e");
    }
  }



 getRendomQuote(){
  Random random=Random();
  
  setState(() { 
QIndex=random.nextInt(4);
  });

 }
getAndSendSms()async{
    List<TContact> contactList =
                        await DatabaseHelper().getContactList();
                    int i = 1;

                    for (TContact contact in contactList) {
                      recipients += contact.number;
                      if (i != contactList.length) {
                        recipients += ";"; // Add a semicolon to separate recipients
                        i++;
                      }
                    }

                    String messageBody =
                        "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}.$_currentAddress";

                    if (await _isPermissionGranted()) {
                      _sendSms(
                        recipients, // Pass the recipients string here
                        "I am in trouble please reach me out at $messageBody",
                        simSlot: 1,
                      );
                    } else {
                      Fluttertoast.showToast(msg: "Something went wrong");
                    }
}
 @override
  void initState() {

    getRendomQuote();
    super.initState();
     _getPermission();
    _getCurrentLocation();
    ///shake feature///
  ShakeDetector.autoStart(
      onPhoneShake: () {
        getAndSendSms();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shake!'),
          ),
        );
        // Do stuff on phone shake
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

    // To close: detector.stopListening();
    // ShakeDetector.waitForStart() waits for user to call detector.startListening();
  
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        
          
          child: Column(children: [
            CoustomAppBar(
              QuatesIndex: QIndex,
              onTap:()
              { getRendomQuote();} ),
              Expanded(child: ListView(
                shrinkWrap: true,
               children: [
                Customcarouel(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Emergency",
                  style: 
                  TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
                Emergency(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Explore liveSafe",
                  style: 
                  TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
                LifeSafe(),
                SafeHome(),
                
               ],
              ))
            
          ],),
        ),
      )
    );
  }
}