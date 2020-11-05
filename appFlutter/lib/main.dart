import 'package:appFlutter/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/salad-background.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Food App',
              style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Padding(padding: EdgeInsets.only(bottom: 19)),
            Text(
              'Welcome to Food App',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Text(
              'Find the best recipes of the World !',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
            ),
            Padding(padding: EdgeInsets.only(bottom: 100)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonTheme(
                  minWidth: 120.0,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color.fromRGBO(159, 211, 5, 1),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                ButtonTheme(
                  minWidth: 120.0,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () {},
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color.fromRGBO(61, 54, 62, 1),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
