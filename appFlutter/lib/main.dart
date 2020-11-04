import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailUser = TextEditingController();
final TextEditingController _passwordUser = TextEditingController();
bool hasClick = false;
String messageError;
bool _success = false;
String _userEmail;
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
      title: 'Firebase Auth Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test firebase'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return ListView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(16),
              children: [
                RegisterEmail(),
              ],
            );
          },
        ));
  }
}

class RegisterEmail extends StatefulWidget {
  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
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
}
