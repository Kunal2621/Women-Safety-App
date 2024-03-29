import 'package:flutter/material.dart';
import 'package:sefty/child/bottom_screens/add_contacts.dart';
import 'package:sefty/child/bottom_screens/chat_pages.dart';
import 'package:sefty/child/bottom_screens/profile_page.dart';
import 'package:sefty/child/bottom_screens/review_page.dart';
import 'package:sefty/child/child_Home_page.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex=0;
  List<Widget> pages=[
    HomeScreen(),
    AddContactsPage(),
    ChatPage(),
    ProfilePage(),
    ReviewPage(),
  ];
  onTapped(int index){
    setState(() {
      currentIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body: pages[currentIndex],
   bottomNavigationBar: BottomNavigationBar(
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: onTapped,
    items: [
      BottomNavigationBarItem(
        label: 'home',
        icon: Icon
        (Icons.home
        )),
        BottomNavigationBarItem(
          label: 'contacts',
        icon: Icon(
          Icons.contacts
          )),
        BottomNavigationBarItem(
          label: 'chats',
        icon: Icon(

          Icons.chat
          )),
          BottomNavigationBarItem(
          label: 'Profile',
        icon: Icon(
          Icons.person
          )),
        BottomNavigationBarItem(
          label: 'Review',
        icon: Icon(

          Icons.reviews
          ))
        
    ]),
    
    );
  }
}