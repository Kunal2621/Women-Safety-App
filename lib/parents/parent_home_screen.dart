import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sefty/chat_module/chat_screen.dart';
import 'package:sefty/child/child_Login_screen.dart';
import 'package:sefty/util/contant.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Container()
            ),
          ListTile(
            title: TextButton(onPressed: ()async{
      try {
       await FirebaseAuth.instance.signOut();
       goTo(context, loginScreen());
      } on FirebaseAuthException catch (e) {
        DialougeBox(context, e.toString());
      }
      },child: Text("SIGN OUT") ,)),
          
          ],

        ),
      ),
      
       appBar:  AppBar(
      backgroundColor :Colors.pink,
      //backgroundColor: Color.fromARGB(255,250,163,192),
        title: Text("SELECT CHILD" ),
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('users')
      .where('type',isEqualTo: 'child')
      .where('guardianEmail',isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots(), 
      builder: (BuildContext context ,AsyncSnapshot <QuerySnapshot>snapshot){
        if (!snapshot.hasData) {
          return Center(child: progressIndicator(context));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context,int index){
          final d=snapshot.data!.docs[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Color.fromARGB(255,250,163,192),
            child: ListTile(
              onTap: () {
                goTo(context, 
                ChatScreen(currentUserId: FirebaseAuth.instance.currentUser!.uid, 
                friendId: d.id,
                 friendName: d['name'],));
                //Navigator.push(context, MaterialPageRoute(builder: builder))
              },
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(d['name']),
              ),
            ),
          ),
        );
        },
        );
      },
    ),
    );
  }
}