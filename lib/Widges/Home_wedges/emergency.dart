import 'package:flutter/material.dart';
import 'package:sefty/Widges/Home_wedges/emergencies/AmbulanceEmergency.dart';
import 'package:sefty/Widges/Home_wedges/emergencies/ArmyEmergency.dart';
import 'package:sefty/Widges/Home_wedges/emergencies/Family&friend.dart';
import 'package:sefty/Widges/Home_wedges/emergencies/FirebrigadeEmergency.dart';

import 'emergencies/policeemergency.dart';

 class Emergency extends StatelessWidget{
  const Emergency ({Key?key}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
         PoliceEmergency(),
         AmbulanceEmergency(),
         FirebrigadeEmergency(),
         ArmyEmergency(),
         Family(),
        ],
      ),
    );
  }

 }