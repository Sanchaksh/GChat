import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_chat/helper/helperfunctions.dart';
import 'package:g_chat/services/auth.dart';
import 'package:g_chat/services/database.dart';
import 'package:g_chat/views/chatRoomsScreen.dart';
import 'package:g_chat/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
//Instantiating the classes that have the functions.
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUP() {
    if(formKey.currentState.validate()) {
      Map<String,String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((value){
        //print("${value}.uId");


        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => chatRoom()
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 3 ? "Username should contain more than 3 characters" : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Username"), //Modularization
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                              ? null : "Please enter correct email";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Email Address"), //Modularization
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length>6 ? null : "Password length should be more than 6 characters";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Password"), //Modularization
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26,),
                GestureDetector(
                  onTap: (){
                    signMeUP();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign Up", style: mediumTextStyle()),
                  ),
                ),

                SizedBox(height: 16,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Sign Up with Google", style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8,),
                        child: Text("Sign In.", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
