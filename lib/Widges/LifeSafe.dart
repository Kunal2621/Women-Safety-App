import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sefty/Widges/Home_wedges/Live_Safe/BusstationCard.dart';
import 'package:sefty/Widges/Home_wedges/Live_Safe/HospitalCard.dart';
import 'package:sefty/Widges/Home_wedges/Live_Safe/PharmecyCard.dart';
import 'package:sefty/Widges/Home_wedges/Live_Safe/PoliceStationCard.dart';
import 'package:url_launcher/url_launcher.dart';

class LifeSafe extends StatelessWidget {
  const LifeSafe({super.key});
  static Future<void> openmap(String location) async { 
    String googleUrl='https://www.google.com/maps/search/$location';
    final Uri _url = Uri.parse(googleUrl);
    try {
      await launchUrl(_url);
    } catch (e) {
    Fluttertoast.showToast(msg: 'Something went wrong! call emergency number');
    }

  }




  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
       PoliceStationCard(onMapFunction:openmap),
       HospitalCard(onMapFunction:openmap),
       PharmecyCard(onMapFunction:openmap),
       BusstationCard(onMapFunction:openmap),


        ],
      ),
    );
  }
}