import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:socialmedialogin_app/Model/UserModel.dart';
import 'package:socialmedialogin_app/View/Login/Login.dart';
import 'package:socialmedialogin_app/ViewModel/Provider/SigninProvider.dart';

class Home extends StatefulWidget {
  final UserModel user;

  const Home({Key? key, required this.user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Gardient Colors----------------
  Color gradientStart =
      Colors.deepPurple.shade700; //Change start gradient color here
  Color gradientEnd = Colors.purple.shade500; //Change end gradient color here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: const FractionalOffset(0.0, 0.5),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
              colors: [gradientStart, gradientEnd])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            child: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.picture), radius: 0),
          ),
          Text(widget.user.name),
          Text(widget.user.email),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  GoogleSignIn().signOut().then((value) => {
                        Navigator.pop(context)
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Login())),
                      });
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    ));
  }
}
