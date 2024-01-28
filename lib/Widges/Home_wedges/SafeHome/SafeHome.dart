import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sefty/Component/PrimaryButton.dart';
import 'package:sefty/db/db_services.dart';
import 'package:sefty/model/constactsm.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
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



  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CURRENT LOCATION IMMEDIATELY",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                PrimaryButton(
                  title: "GET LOCATION",
                  onPressed: () {
                    _getCurrentLocation();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                PrimaryButton(
                  title: "SEND ALERT",
                  onPressed: () async {
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
                  },
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafeHome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Send Location"),
                      subtitle: Text("Share Location"),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/Share location.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
