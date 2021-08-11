import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedialogin_app/View/Login/Login.dart';
import 'ViewModel/Provider/SigninProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SigninProvider>(create: (_) => SigninProvider()),
      ],
      child: MaterialApp(
          title: 'SocialMediaLoginApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'BalooChettan2',
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Colors.white, fontSizeDelta: 1)),
          home: Login()),
    );
  }
}
