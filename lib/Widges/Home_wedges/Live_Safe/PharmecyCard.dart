import 'package:flutter/material.dart';

class PharmecyCard extends StatelessWidget {
  final Function? onMapFunction;
  const PharmecyCard({Key? key,this.onMapFunction}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
    children: [
    InkWell(
      onTap: (){
      onMapFunction!(' medical store near me');
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
        height: 60,
        width: 60,
        child: Center(
          child: Image.asset('assets/pharmecy.png',
          height: 32,),
        ),
        ),
      ),
    ),
       Text('Medical'),
    ],
      ),
    );
  }
}