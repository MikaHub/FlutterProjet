import 'package:appFlutter/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => WelcomePage())),
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color.fromRGBO(159, 211, 5, 1),
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/salad-LoginBackground.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
          ),
        ),
        child: RegisterEmail(),
      ),
    );
  }
}

class RegisterEmail extends StatefulWidget {
  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailUser = TextEditingController();
  final TextEditingController _passwordUser = TextEditingController();
  bool hasClick = false;
  String messageError;
  bool _success = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
          Container(
            width: 300,
            margin: EdgeInsets.only(left: 30, top: 50, right: 30),
            child: TextFormField(
              controller: _emailUser,
              onSaved: (input) => _emailUser.text = input,
              decoration: const InputDecoration(
                hintText: 'Enter you name',
                labelText: 'Email',
                labelStyle: TextStyle(
                    height: 0.5,
                    fontSize: 25,
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
            margin: EdgeInsets.all(30),
            child: TextFormField(
              controller: _passwordUser,
              onSaved: (input) => _passwordUser.text = input,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
                labelStyle: TextStyle(
                    height: 0.5,
                    fontSize: 25,
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
                    _register();
                  }
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
          ),
          Container(
            alignment: Alignment.center,
            child: hasClick ? Text(messageError) : Text(''),
          ),
          Wrap(
            children: [
              Container(
                margin: EdgeInsets.only(top: 130),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    InkWell(
                      child: Text(
                        ' Register !',
                        style: TextStyle(
                            color: Color.fromRGBO(159, 211, 5, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {},
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
        /*  Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home())); */
      } catch (e) {
        print(e.message);
      }
    }
  }
}
