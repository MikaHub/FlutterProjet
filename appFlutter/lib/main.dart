import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Home.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailUser = TextEditingController();
final TextEditingController _passwordUser = TextEditingController();
bool hasClick = false;
String messageError;
bool _success = false;
final FirebaseAuth _auth = FirebaseAuth.instance;

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
      title: 'Firebase Auth Demo',
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      onPressed: () {},
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
      ),
    );
  }
}

class RegisterEmail extends StatefulWidget {
  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  String _userEmail;

  void dispose() {
    _emailUser.dispose();
    _passwordUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailUser,
            onSaved: (input) => _emailUser.text = input,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordUser,
            onSaved: (input) => _passwordUser.text = input,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  hasClick = true;
                  _register();
                }
              },
              child: const Text('Submit'),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () {
                signIn();
              },
              child: const Text('Connexion de bg'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: hasClick ? Text(messageError) : Text(''),
          )
        ],
      ),
    );
  }

  void _register() async {
    if (_passwordUser.text.length < 6) {
      setState(() {
        messageError = 'Password must be 6 length minimum';
      });
    }
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailUser.text,
      password: _passwordUser.text,
    ))
        .user;
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print(e);
    }

    print(user);
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = _emailUser.text;
        messageError = 'TRUE REGISTER';
        _emailUser.text = '';
        _passwordUser.text = '';
      });
    } else {
      setState(() {
        messageError = 'FALSE REGISTER';
        _success = false;
        print('Aie');
      });
    }

    if (_success) {
      setState(() {
        messageError = 'Compte good';
      });
    } else {
      setState(() {
        messageError = 'Error acc';
      });
    }
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailUser.text, password: _passwordUser.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('zret'),
    );
  }
}
