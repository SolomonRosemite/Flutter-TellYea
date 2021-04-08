import 'package:TellYea/pages/login/utilities/constants.dart';
import 'package:TellYea/backend/SharedPreferences.dart';
import 'package:TellYea/backend/backend.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // User Data
  String _displayName = "";
  String _username = "";
  String _email = "";
  String _password = "";

  // UI Stuff
  bool _loginButtonClick = false;
  bool _showLogin = false;

  String alertMessage = "";

  void registerUser() async {
    setState(() {
      alertMessage = "";
    });
    if (_loginButtonClick == true) {
      return;
    }

    _loginButtonClick = true;
    _email = _email.toLowerCase();
    _email = _email.trimRight();
    _email = _email.trimLeft();

    if (_displayName.length <= 3 || _displayName.length > 20) {
      alertUser('DisplayName must be at leas 4 to 20 characters long');
      return;
    }

    if (_username.length <= 3 || _username.length > 16) {
      alertUser('Username must be at leas 4 to 16 characters long');
      return;
    }

    if (_username.contains(' ')) {
      alertUser('Username Can\'t contain White-Spaces');
      return;
    }

    if (_username.contains('@')) {
      alertUser('Username Can\'t contain @');
      return;
    }

    if (!_email.contains('@') || !_email.contains('.')) {
      alertUser('Email is not valid');
      return;
    }

    if (_password.isEmpty) {
      alertUser('Please fill in a Password');
      return;
    }

    for (Map item in await Backend.readTable('TellYeaUsers')) {
      if (_username.toLowerCase() == item['username'].toLowerCase()) {
        alertUser('Username is taken');
        return;
      }
    }

    bool registeredSuccessfully = await Backend.registerUser(_displayName, _username, _email, _password);

    if (registeredSuccessfully == true) {
      saveToSharedPreferences();
      Navigator.pop(context);
      return;
    }

    alertUser('Something went wrong. Plese try again');

    Backend.save('Reports', {
      'context': 'Something went wrong here. File: login_screen Method: registerUser Username: $_username Email: $_email Password: $_password'
    });
  }

  void loginUser() async {
    setState(() {
      alertMessage = "";
    });
    if (_loginButtonClick == true) {
      return;
    }

    _loginButtonClick = true;
    _email = _email.toLowerCase();
    _email = _email.trimRight();
    _email = _email.trimLeft();

    if (!_email.contains('@') || !_email.contains('.')) {
      alertUser('Email is not valid');
      return;
    }

    if (_password.isEmpty) {
      alertUser('Please fill in a Password');
      return;
    }

    if (await Backend.loginUser(_email, _password) == true) {
      saveToSharedPreferences();
      Navigator.pop(context);
      return;
    }
    alertUser('Email or Password seems to be not right\nTry again');
  }

  void saveToSharedPreferences() {
    MySharedPreferences.setString('email', _email);
    MySharedPreferences.setString('password', _password);
  }

  void alertUser(String context) {
    // Here we Alert the user if something didn't go right.
    // Example: Username is taken..
    setState(() {
      alertMessage = context;
    });
    _loginButtonClick = false;
  }

  Widget _buildNameTF() {
    if (_showLogin) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (displayName) => this._displayName = displayName,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person_pin_circle,
                color: Colors.white,
              ),
              hintText: 'Enter your Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameTF() {
    if (_showLogin) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (username) => this._username = username,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Enter your Username',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Text(
          'Email',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (email) => this._email = email,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Text(
          'Password',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            onChanged: (password) => this._password = password,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    if (_showLogin) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            elevation: MaterialStateProperty.all(5.0),
            padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(30.0),
            // ),
            // color: Colors.white,
          ),
          onPressed: () => loginUser(),
          child: Text(
            'Login'.toUpperCase(),
            style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(5.0),
          padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(30.0),
          // ),
        ),
        onPressed: () => registerUser(),
        child: Text(
          'Register'.toUpperCase(),
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    if (_showLogin) {
      return GestureDetector(
        onTap: () => switchPage(),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Want to Sign Up? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () => switchPage(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Want to Login? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void switchPage() {
    setState(() {
      alertMessage = "";
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [
                        0.1,
                        0.4,
                        0.7,
                        0.9
                      ],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 80.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _showLogin ? 'Login' : 'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          alertMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        _buildNameTF(),
                        _buildUsernameTF(),
                        _buildEmailTF(),
                        _buildPasswordTF(),
                        _buildRegisterBtn(),
                        _buildLoginBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
