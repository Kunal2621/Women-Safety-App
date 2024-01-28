 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sefty/Component/PrimaryButton.dart';
import 'package:sefty/Component/SeondaryButton.dart';
import 'package:sefty/Component/custom_textfield.dart';
import 'package:sefty/child/bottom_page.dart';
import 'package:sefty/child/register_child.dart';
import 'package:sefty/db/shared_pref.dart';
import 'package:sefty/parents/parent_home_screen.dart';
import 'package:sefty/parents/parent_regester_screen.dart';
import 'package:sefty/util/contant.dart';

class loginScreen extends StatefulWidget{

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool isPasswordShow=true;
  final _formKey=GlobalKey<FormState>();
  final _formData=Map<String,Object>();
  bool isLoading=false;
  _onSubmit() async{
    _formKey.currentState!.save();
   try {
   setState(() {
     isLoading =true;
   });
  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _formData['email'].toString(),
    password: _formData['password'].toString(),
    
  );
  if(userCredential.user!=null){
    
     setState(() {
     isLoading =false;
   });
   FirebaseFirestore.instance
   .collection('users').
   doc(userCredential.user!.uid).
   get().
   then((value){
    if (value['type']=='parent') {
      print(value['type']);
      MySharedPrefference.saveUserType('parent');
      goTo(context, ParentHomeScreen());   
      
    }
   else{
     MySharedPrefference.saveUserType('child');
goTo(context, BottomPage());
   }

   });
   
  }
} on FirebaseAuthException catch (e) {
   setState(() {
     isLoading =false;
   });
  if (e.code == 'user-not-found') {
    DialougeBox(context, 'No user found for that email.');
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    DialougeBox(context, 'Wrong password provided for that user.');
    print('Wrong password provided for that user.');
  }
}
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    
     return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading?
                progressIndicator(context):
              SingleChildScrollView(
                child: Column( 
                  children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("user login",
                        style: TextStyle(fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),),
                        Image.asset('assets/login.png',
                    height: 100,
                    width: 100,),
                      ],
                    ),
                  ),
                  
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextField(
                          hintText: "enter email",
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.emailAddress,
                          prefix: Icon(Icons.person),
                          onsave: (email) {
                            _formData['email']=email??"";
                          },
                          validate: (email) {
                            if (email!.isEmpty||email.length<3||!email.contains("@")) {
                              return 'enter correct email';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                      hintText: "enter Password",
                      isPassword: isPasswordShow,
                      prefix: Icon(Icons.vpn_key_rounded),
                      onsave: (password) {
                            _formData['password']=password??"";
                          },
                       validate: (password) {
                            if (password!.isEmpty||password.length<7) {
                              return 'enter correct password';
                            }
                            return null;
                          },
                      suffix: IconButton(onPressed: (){
                        setState(() {
                          isPasswordShow=!isPasswordShow;
                        });
                        
                  
                  
                      }, icon:isPasswordShow?Icon(Icons.visibility_off): 
                      Icon(Icons.visibility)),
                    ),
                    PrimaryButton(title: "Login", 
                    onPressed: (){
                      {
                        if (_formKey.currentState!.validate()) {
                          _onSubmit();
                        }
                      }
                    }),
                      ],
                    ),
                  ),
                ), 
                      
                     Container(
                       child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Text("Forgot PassWord?",
                       style: TextStyle(fontSize: 18,color: Colors.black),
                       ),
                     
                   SecondaryButton(title: 'click here', onPressed: (){}),
                 ],
                       ),
                     ),
                     SecondaryButton(title: 'REGISTER AS CHILD', onPressed: (){
                      goTo(context, RegisterChildScreen());
                     
                     }),SecondaryButton(title: 'REGISTER AS PARENTS', onPressed: (){
                      goTo(context, RegisterParentScreen());
                     
                     }),
                    ],),
              ),
            ],
          ),
        )
      ),
     );
  }
}