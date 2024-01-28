import 'package:flutter/material.dart';

class BusstationCard extends StatelessWidget {
  final Function? onMapFunction;
  const BusstationCard({Key? key,this.onMapFunction}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
    children: [
    InkWell(
      onTap: (){
      onMapFunction!('Bus stop near me');
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
        height: 60,
        width: 60,
        child: Center(
          child: Image.asset('assets/bus stop.jpg',
          height: 32,),
        ),
        ),
      ),
    ),
       Text('Bus staion'),
    ],
      ),
    );
  }
}