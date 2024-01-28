

import 'package:flutter/material.dart';
import 'package:sefty/util/Quates.dart';

 // ignore: must_be_immutable
 class CoustomAppBar extends StatelessWidget { 
  //const CoustomAppBar({super.key});
   Function? onTap;
 int? QuatesIndex;
 CoustomAppBar({this.onTap,this.QuatesIndex});
   @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        child: Text(SweetSaying[QuatesIndex!],
    
        style: TextStyle(fontSize: 22), 
         
         ),
      ),
    );
  }
}
