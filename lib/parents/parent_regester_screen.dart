import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sefty/Component/PrimaryButton.dart';
import 'package:sefty/Component/SeondaryButton.dart';
import 'package:sefty/Component/custom_textfield.dart';
import 'package:sefty/child/child_Login_screen.dart';
import 'package:sefty/model/user_model.dart';
import 'package:sefty/util/contant.dart';

class RegisterParentScreen extends StatefulWidget {
  @override
  State<RegisterParentScreen> createState() => _RegisterParentScreenState();
}

class _RegisterParentScreenState extends State<RegisterParentScreen> {
 bool isPasswordShow=true;
 bool isretypePasswordShow=true;
  final _formKey=GlobalKey<FormState>();

  final _formData=Map<String,Object>();
  bool isLoading=false;
  

 _onSubmit()async{
    _formKey.currentState!.save();
   progressIndicator(context);
    if (_formData['password']!=_formData['rpassword']) {
      DialougeBox(context, 'password and retype password should be equal');
    }else{
      progressIndicator(context);
      try{
        setState(() {
          isLoading =true;
        });
        UserCredential userCredntial= await FirebaseAuth.instance.
        createUserWithEmailAndPassword(email: _formData['gemail'].toString() ,
    password: _formData['password'].toString());
    if(userCredntial.user !=null)
    {
      final v =userCredntial.user !.uid;
      DocumentReference<Map<String, dynamic>>
       db=FirebaseFirestore.instance.collection('users').doc(v);
      
       final user= UserModel(
        name: _formData['name'].toString(),
        phone: _formData['phone'].toString(),
        childEmail: _formData['cemail'].toString(),
        guardianEmail: _formData['gemail'].toString(),
        id: v,
       
        type: 'parent'
       );
       final jsonData=user.toJson();
       await db.set(jsonData).whenComplete((){
    goTo(context,loginScreen());
       });
    

    }
        }
      
      on FirebaseAuthException catch (e){
        DialougeBox(context, e.toString());
      }
      catch(e){
 DialougeBox(context, e.toString());
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
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                      isLoading?
                progressIndicator(context):
                     Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          child: Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Register As Parent",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),),
                              Image.asset('assets/login.png',
                          height: 100,
                          width: 100,),
                            ],
                          ),
                        ),
                         Container(
                    height: MediaQuery.of(context).size.height*0.75,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextField(
                            hintText: "enter name",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.name,
                            prefix: Icon(Icons.person),
                            onsave: (name) {
                              _formData['name']=name??"";
                            },
                            validate: (email) {
                              if (email!.isEmpty||email.length<3) {
                                return 'enter correct name';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            hintText: "enter phone ",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.phone,
                            prefix: Icon(Icons.phone),
                            onsave: (phone) {
                              _formData['phone']=phone??"";
                            },
                            validate: (email) {
                              if (email!.isEmpty||email.length<10) {
                                return 'enter correct phone';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            hintText: "enter email",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.person),
                            onsave: (email) {
                              _formData['gemail']=email??"";
                            },
                            validate: (email) {
                              if (email!.isEmpty||email.length<3||!email.contains("@")) {
                                return 'enter correct email';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            hintText: "enter child email",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.person),
                            onsave: (cemail) {
                              _formData['cemail']=cemail??"";
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
                      CustomTextField(
                        hintText: "conform Password",
                        isPassword: isretypePasswordShow,
                        prefix: Icon(Icons.vpn_key_rounded),
                        onsave: (password) {
                              _formData['rpassword']=password??"";
                            },
                         validate: (password) {
                              if (password!.isEmpty||password.length<7) {
                                return 'enter correct password';
                              }
                              return null;
                            },
                        suffix: IconButton(onPressed: (){
                          setState(() {
                            isretypePasswordShow=!isretypePasswordShow;
                          });
                          
                    
                    
                        }, icon:isretypePasswordShow?Icon(Icons.visibility_off): 
                        Icon(Icons.visibility)),
                      ),
                      PrimaryButton(title: "REGISTER", onPressed: (){
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
                        
                       
                   SecondaryButton(title: 'Login with your accound', onPressed: (){
                        goTo(context, loginScreen());
                       
                       }),
                      
                        
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}