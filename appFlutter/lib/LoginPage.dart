import 'package:appFlutter/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'RegisterPage.dart';
import 'HomePage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoginPage Page',
      home: _LoginPage(),
    );
  }
}

class _LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
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
        title: Text('LoginPage'),
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
        child: _FormLogin(),
      ),
    );
  }
}

class _FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<_FormLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailUser = TextEditingController();
  final TextEditingController _passwordUser = TextEditingController();
  bool hasClick = false;
  String messageError;

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
            margin: EdgeInsets.only(right: 30, left: 30, top: 18),
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
                    signIn();
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
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    InkWell(
                      child: Text(
                        'Register!',
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
                                builder: (context) => RegisterPage()));
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

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailUser.text, password: _passwordUser.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        setState(() {
          messageError = 'Aie aie aie';
        });
        print(e.message);
      }
    }
  }
}
