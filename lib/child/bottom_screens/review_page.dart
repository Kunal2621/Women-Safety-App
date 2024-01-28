

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sefty/Component/PrimaryButton.dart';
import 'package:sefty/Component/custom_textfield.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController locationC=TextEditingController();
   TextEditingController ViewC=TextEditingController();
  bool isSaving =false;
  showAlert(BuildContext context){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        
     title: Text("Review your place"),
     content: Form(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            hintText: 'enter location',
            controller: locationC,
          ),
        ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: CustomTextField(
            controller: ViewC,
            hintText: 'enter location',
             maxLines: 3,
           ),
         ),

      ],
     )),
     actions: [

      
      PrimaryButton(title: "Save", onPressed: ()
      { saveReview();
      Navigator.pop(context);
      }),
      TextButton(child: Text("CANCEL"),onPressed: (){
        Navigator.pop(context);
      }),

     ],
      );
    });
  }
  saveReview() async{
  setState(() {
    isSaving =true;
  });
   await FirebaseFirestore.instance.collection('reviews').add(
    {'location':locationC.text,
    'views': ViewC.text, } ).then((value) {
      setState(() {
        isSaving=false;
        Fluttertoast.showToast(msg: 'review uploaded successfully');
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      isSaving==true?Center(child: CircularProgressIndicator()) :
      Column(
        children: [
         // Text("Recent Review by other",style: TextStyle(fontSize: 20),),
          Expanded(
            child: StreamBuilder(stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
             builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder
              (itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext conteext,int index){
                final data=snapshot.data!.docs[index];
             return Padding(
               padding: const EdgeInsets.all(3.0),
               child: Card(
                elevation: 10,
               // color: Colors.primaries[Random().nextInt(20)],
                child: ListTile(title: Text(data['location'],style: TextStyle(fontSize: 20),),
                subtitle: Text(data['views']),
                ),
               ),
             );
              },);
            }),
          ),
        ],
      ),
      floatingActionButton:FloatingActionButton(onPressed: (){
        showAlert(context); 
      },
      backgroundColor: Colors.blue,
      child: Icon(Icons.add),)
    );
  }
}