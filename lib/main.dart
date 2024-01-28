
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sefty/child/bottom_page.dart';
import 'package:sefty/child/child_Login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sefty/db/shared_pref.dart';
import 'package:sefty/parents/parent_home_screen.dart';
import 'package:sefty/util/contant.dart';
//import 'package:sefty/util/flutter_backround_servises.dart';
 Future<void> main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(); 
 await MySharedPrefference.init();
 // await initializeServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(future: MySharedPrefference.getUserType(), 
      
      
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        
        if (snapshot.data=="") {
          return loginScreen();
        } 
        if (snapshot.data=="child") {
          return BottomPage();
        } 
       if (snapshot.data=="parent") {
          return ParentHomeScreen();
        } 
        return progressIndicator(context);


      },
      ),
      );
       
  }
}
//class CheckAuth extends StatelessWidget {
 // const CheckAuth({Key? key}):super(key: key)
 //checkData(){
  //if(MySharedPrefference.getUserType()=='parent')
 //}

  //@override
  //Widget build(BuildContext context) {
    //return Scaffold(

    //);
  //}
//}
