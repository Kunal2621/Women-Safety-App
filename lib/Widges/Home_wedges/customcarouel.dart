import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:sefty/Widges/Home_wedges/safewebview.dart';
import 'package:sefty/util/Quates.dart';

class Customcarouel extends StatelessWidget{
  const  Customcarouel({Key? key}):super(key: key);
  void nevigateToRout(BuildContext context,Widget route){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      child: CarouselSlider(
       options: CarouselOptions(
        aspectRatio: 2.0,
        autoPlay: true,
        enlargeCenterPage: true,

       ),
       items: List.generate(imageSliders.length, (index) => Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        
        ),
        child: InkWell(
          onTap: () {
            if(index==0){
              context;
              safewebview(url: "https://www.woodenstreet.com/blog/15-firsts-by-indian-women-who-have-made-the-nation-proud");
            }
            else if(index==1){
              context;
             safewebview(url: "https://www.unwomen.org/en/what-we-do/ending-violence-against-women#:~:text=One%20in%20three%20women%20worldwide,can%20be%20devastating%2C%20including%20death.");
            } 
            else if(index==2){
              context;
              safewebview(url: "https://www.healthline.com/health/womens-health/self-defense-tips-escape");
            }else{
              context;
              safewebview(url: " https://www.forbes.com/sites/amymorin/2020/02/11/7-things-mentally-strong-women-believe/?sh=794aa2dc1b4e");
            }
          },
          child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),   
            
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(imageSliders[index],
        
             )) ),
             child :Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.5),
              Colors.transparent,
            ]),    
              ),
               child: Align(
                alignment: Alignment.bottomLeft,
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 8,left: 8),
                 child: Text(articleTitle[index],style: TextStyle(fontWeight: FontWeight.bold,
                 color: Colors.white,
                 fontSize: MediaQuery.of(context).size.width*0.05,),),
               ),),
             )
          ),
        ),
       ),
       ),
      ),
    );
    
  }
  
}