import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:socialmedialogin_app/Model/UserModel.dart';
import 'package:twitter_login/twitter_login.dart';

class SigninProvider with ChangeNotifier {
  bool googleUser = false;
  bool facebookUser = false;

  late UserModel user;

//SignIN Using Google GMail--------------------
  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    var googleAccount = await GoogleSignIn().signIn();

    if (googleAccount != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      // Create a new credential
      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var userData =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(userData.credential!.providerId);
      //Converting into Map
      Map<String, dynamic> s = {
        'name': userData.user!.displayName,
        'email': userData.user!.email,
        'picture': userData.user!.photoURL
      };

      //Converting into UserModel
      user = UserModel.fromJson(s);

      print(user.name);
      googleUser = true;

      // Once signed in, return the UserCredential
      notifyListeners();
      return user;
    } else {
      return null;
    }
  }

//Signin with Facebook ---------------------------------------------
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<UserModel?> loginwithfb() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    try {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          print("LoggedIN");
          final token = result.accessToken.token;

          var url = Uri.parse(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
          final graphResponse = await http.get(url);
          facebookUser = true;
          var userData = await JSON.jsonDecode(graphResponse.body);
          print(userData);

          //Converting into Map
          Map<String, dynamic> s = {
            'name': userData['name'],
            'email': userData['email'],
            'picture': userData['picture']['data']['url']
          };

          user = UserModel.fromJson(s);
          print(user.email);
          return user;

        case FacebookLoginStatus.cancelledByUser:
          print("Cancelled By User");
          return null;
        case FacebookLoginStatus.error:
          print(result.errorMessage);
          return null;
      }
    } catch (e) {
      print(e);
    }
  }

//Sign in With Twitter------------------------------------------------
  Future<UserModel?> signInWithTwitter() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final TwitterLogin twitterLogin = TwitterLogin(
      apiKey: "5KrujbvVmVZI2mAvgQK7JKfRp",
      apiSecretKey: "DKQj1dh4dyx39RTmZxsjqFO8KqAWtsRduZzUeyNvZzLziPcJHc",
      redirectURI:
          "https://social-media-loginapp.firebaseapp.com/__/auth/handler",
    );

    /// login(forceLogin: true);
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential twitterAuthCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);
        print("sUCCESS");
        final userCredential =
            await _auth.signInWithCredential(twitterAuthCredential);
        if (userCredential != null) {
          print(userCredential.user!.displayName);
          print(userCredential.credential!.providerId);

          Map<String, dynamic> s = {
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'picture': userCredential.user!.photoURL
          };

          //Converting into UserModel
          user = UserModel.fromJson(s);
          return user;
        } else {
          return null;
        }

      case TwitterLoginStatus.cancelledByUser:
        print("Cancelled By USER");
        return null;

      case TwitterLoginStatus.error:
        print("ERROR");
        return null;

      default:
        return null;
    }
  }
}
