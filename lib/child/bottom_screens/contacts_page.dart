import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sefty/db/db_services.dart';
import 'package:sefty/model/constactsm.dart';
import 'package:sefty/util/contant.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key?key}):super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List <Contact>contacts=[];
  List <Contact>contactsFilter=[];
  DatabaseHelper _databaseHelper=DatabaseHelper();

  TextEditingController searchcontroller=TextEditingController();
  void initState(){
    super.initState();
    askPermission();
  }
String flattenPhoneNumber(String phoneStr){
  return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'),(Match m){
    return m[0]=="+"?"+": "";
  });
}

filterContact(){
List <Contact>contacts=[];
contacts.addAll(contacts);
if (searchcontroller.text.isNotEmpty) {
  contacts.retainWhere((element) {
String searchTerm=searchcontroller.text.toLowerCase();
String searchTermFlattren=flattenPhoneNumber(searchTerm);
String contactName=element.displayName!.toLowerCase();
contactName.contains(searchTerm);
bool nameMatch =contactName.contains(searchTerm);
if (nameMatch==true) {
  return true;

}
if (searchTermFlattren.isEmpty) {
  return false;
} 
var phone= element.phones!.firstWhere((p) {
  String phnFlattered =flattenPhoneNumber(p.value!);
  return phnFlattered.contains(searchTermFlattren);
});
return phone.value!=null;


  });
}
setState(() {
  contactsFilter=contacts;
});
}

  Future <void> askPermission()async{
    PermissionStatus permissionStatus=await getContactsPermission();
    if (permissionStatus==PermissionStatus.granted) {
    getAllContact();
    searchcontroller.addListener(() { 
      filterContact();
    });
      
    } else {
      handleInvalidPermission(permissionStatus);
    }
  }
 handleInvalidPermission(PermissionStatus permissionStatus){
  if (permissionStatus==PermissionStatus.denied) {
    DialougeBox(context, "Access to the contacts denied by the user");
  } 
  else if (permissionStatus==PermissionStatus.permanentlyDenied) 
  {
    DialougeBox(context, "May Contect does not exits in this device");
    
  }
 }

  Future<PermissionStatus> getContactsPermission() async{
    PermissionStatus permission =await Permission.contacts.status;
    if (permission!=PermissionStatus.granted 
    &&permission!=PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus=await Permission.contacts.request();
      return permissionStatus;
    }else{
      return permission;
    }

  }
    getAllContact() async{
List<Contact> _contacts=await ContactsService.getContacts(
  withThumbnails: false
);
setState(() {
  contacts= _contacts;
});
    }
  @override
  Widget build(BuildContext context) {
    bool isSearchInd=searchcontroller.text.isNotEmpty;
    bool ListItemExit=(contactsFilter.length>0||contacts.length>0);
    return Scaffold(

      body: contacts.length==0?
      Center
      (child: CircularProgressIndicator()):

      SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: searchcontroller,
                decoration: InputDecoration(
                  labelText: "search contact",
                  prefixIcon: Icon(Icons.search)
                ),
                
              ),
            ),
            ListItemExit==true?
            Expanded(
              child: ListView.builder(
                itemCount:isSearchInd==true?contactsFilter.length:contacts.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact= isSearchInd==true 
                ?contactsFilter[index]:
                 contacts[index];
                return ListTile(
                  title: Text(contact.displayName!),
                  //subtitle: Text(contact.phones!.elementAt(0).value!),
                  leading:contact.avatar!=null &&contact.avatar!.length>0?
                   CircleAvatar(
                    backgroundColor: primaryColor,
                    backgroundImage: MemoryImage(contact.avatar!)
              ,): CircleAvatar
              (
                backgroundColor: primaryColor,
                child: Text(contact.initials()
                ),
              ),
              onTap: () {
                if (contact.phones!.length>0) {
                  final String PhoneNum=contact.phones!.elementAt(0).value!;
                  final String name = contact.displayName!;
                  _addContact(TContact(PhoneNum, name));

                } else {
                  Fluttertoast.showToast(msg: "Oops! phone number does not exist  ");
                }
              },
                );
              },
               ),
            ) :Container(
              child: Text("searching"),
            ),
          ],
        ),
      )
    );
  }
  void _addContact(TContact newContact) async{
   int result= await _databaseHelper.insertContact(newContact);
   if (result!=0) {
     Fluttertoast.showToast(msg: "contact added successfully");
      Navigator.pop(context, true);
   }else {
    Fluttertoast.showToast(msg: "contact faild to add ");
     Navigator.pop(context, false);
   }
Navigator.pop(context,true);
  }
}