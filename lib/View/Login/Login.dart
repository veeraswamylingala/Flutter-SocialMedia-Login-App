import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socialmedialogin_app/Constants/Constants.dart';
import 'package:socialmedialogin_app/View/Home/Home.dart';
import 'package:socialmedialogin_app/ViewModel/Provider/SigninProvider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  //Gardient Colors----------------
  Color gradientStart =
      Colors.deepPurple.shade700; //Change start gradient color here
  Color gradientEnd = Colors.purple.shade500; //Change end gradient color here

  final emailTFC = new TextEditingController();
  final passwordTFC = new TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  //EmailValidation Function-------------------
  validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    var res = regex.hasMatch(value);
    print(res);
    setState(() {
      emailError = !res;
    });
    // return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    var signIn = Provider.of<SigninProvider>(context);

    return Scaffold(
      body: Container(
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: const FractionalOffset(0.0, 0.5),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                  colors: [gradientStart, gradientEnd])),
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Log In",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Let's go to work"),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: emailTFC,
                        style: TextStyle(color: Colors.grey.shade800),
                        onChanged: (val) {
                          _formKey.currentState!.validate();
                          validateEmail(val);
                        },
                        autofocus: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email Required";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            errorText: emailError ? "Enter Valid Email" : null,
                            // counterText: "100",
                            filled: true,
                            fillColor: Colors.grey[300],
                            hintText: 'Email'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordTFC,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        style: TextStyle(color: Colors.grey.shade800),
                        onChanged: (val) {
                          _formKey.currentState!.validate();
                        },
                        autofocus: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Password Required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            // errorText: passwordError ? "Password Required" : null,
                            // counterText: "Error",
                            filled: true,
                            focusColor: Colors.green,
                            fillColor: Colors.grey[300],
                            hintText: 'Password'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Fotgot Password Clicked");
                        },
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "FORGOT PASSWORD?",
                              style: TextStyle(fontSize: 13),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            print("Success");
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Home()));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 40,
                          color: Colors.blue.shade500,
                          child: InkWell(
                            focusColor: Colors.black,
                            hoverColor: Colors.red,
                            splashColor: Colors.pink,
                            highlightColor: Colors.green,
                            child: Text(
                              "LOG IN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("or log in with your social media credentials"),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              openLoadingDialog(context, "Signing In...");
                              signIn.loginwithfb().then((value) => {
                                    print(value),
                                    Navigator.pop(context),
                                    print("Facebook Clikced"),
                                    if (value != null)
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home(user: value)))
                                      }
                                  });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                child: FaIcon(FontAwesomeIcons.facebookF)),
                          ),
                          SizedBox(
                            width: 35,
                          ),
                          GestureDetector(
                            onTap: () {
                              openLoadingDialog(context, "Signing In...");
                              signIn.signInWithGoogle(context).then((value) => {
                                    Navigator.pop(context),
                                    if (value != null)
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home(
                                                      user: value,
                                                    ))),
                                        print("Google Clikced")
                                      }
                                  });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                child: FaIcon(FontAwesomeIcons.googlePlusG)),
                          ),
                          SizedBox(
                            width: 35,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Twitter Clikced");
                              openLoadingDialog(context, "Signing In...");
                              signIn.signInWithTwitter().then((value) => {
                                    print(value),
                                    Navigator.pop(context),
                                    if (value != null)
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home(user: value)))
                                      }
                                  });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: FaIcon(FontAwesomeIcons.twitter)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
              Container(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    SizedBox(
                      width: 7,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("signup Clicked");
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
