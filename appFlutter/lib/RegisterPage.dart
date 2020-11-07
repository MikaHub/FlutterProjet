import 'package:appFlutter/LoginPage.dart';
import 'package:appFlutter/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoginPage Page',
      home: _RegisterPage(),
    );
  }
}

class _RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => //Navigator.pop(context),
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => WelcomePage())),
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color.fromRGBO(159, 211, 5, 1),
        centerTitle: true,
        title: Text('Register Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/salad-loginBackground.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
          ),
        ),
        child: _FormRegister(),
      ),
    );
  }
}

class _FormRegister extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}

class _FormRegisterState extends State<_FormRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameUser = TextEditingController();
  final TextEditingController _emailUser = TextEditingController();
  final TextEditingController _passwordUser = TextEditingController();
  bool hasClick = false;
  String messageError;
  bool _success = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void dispose() {
    _emailUser.dispose();
    _passwordUser.dispose();
    _nameUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 300,
            margin: EdgeInsets.only(left: 30, top: 50, right: 30),
            child: TextFormField(
              controller: _nameUser,
              onSaved: (input) => _nameUser.text = input,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Name',
                labelStyle: TextStyle(
                    height: 0.5,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
            width: 300,
            margin: EdgeInsets.only(left: 30, top: 18, right: 30),
            child: TextFormField(
              controller: _emailUser,
              onSaved: (input) => _emailUser.text = input,
              decoration: const InputDecoration(
                hintText: 'mymail@domain.com',
                labelText: 'Email',
                labelStyle: TextStyle(
                    height: 0.5,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 18, left: 30, right: 30),
            child: TextFormField(
              controller: _passwordUser,
              onSaved: (input) => _passwordUser.text = input,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
                labelStyle: TextStyle(
                    height: 0.5,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            margin: EdgeInsets.only(top: 70),
            alignment: Alignment.center,
            child: ButtonTheme(
              minWidth: 120.0,
              height: 40,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    hasClick = true;
                    register();
                  }
                },
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                color: Color.fromRGBO(159, 211, 5, 1),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: hasClick ? Text(messageError) : Text(''),
          ),
          Wrap(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Text(
                        'I have an account',
                        style: TextStyle(
                            color: Color.fromRGBO(159, 211, 5, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void register() async {
    if (_passwordUser.text.length < 6) {
      setState(() {
        messageError = 'Password must be 6 length minimum';
      });
    } else if (!_emailUser.text.contains('@')) {
      messageError = 'Error with mail';
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

    if (user != null) {
      setState(() {
        _success = true;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      setState(() {
        _success = false;
        _emailUser.text = '';
        _passwordUser.text = '';
        _nameUser.text = '';
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
