import 'package:flutter/material.dart';
import 'package:firm_body_flutter/services/authentication.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  bool _isLoading = false;
  bool _isIos;
  FormMode _formMode = FormMode.LOGIN;
  String _errorMessage;
  final _formKey = GlobalKey<FormState>();

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        _isLoading = false;
        setState(() {});
        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        _isLoading = false;
        _errorMessage = 'Incorrect Values';
        //TODO: Handle Exceptions
        // https://github.com/flutter/flutter/issues/20223#issue-347613208

        setState(() {});
      }
    } else {
      _isLoading = false;
      setState(() {
        _errorMessage = "Write Email and Password";
      });
    }
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendResetPasswordEmail() async {
    _formKey.currentState.save();
    try {
      await widget.auth.resetPS(_email);
      _showVerifyEmailSentDialog();
    } catch (e) {
      print(e);
      _errorMessage = 'Invalid email';
      setState(() {});
    }
  }

  Widget _showCircularSpinner() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  Widget _showLogo() {
    return Hero(
      tag: 'loginLogo',
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 50.0,
          child: Image.asset('images/Picture1.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.redAccent.withOpacity(0.5)),
          icon: Icon(Icons.email, color: Colors.redAccent),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.redAccent.withOpacity(0.5)),
            icon: new Icon(
              Icons.lock,
              color: Colors.redAccent,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: MaterialButton(
          onPressed: _validateAndSubmit,
          elevation: 5.0,
          minWidth: 100.0,
          height: 42.0,
          color: Colors.redAccent,
          child: _formMode == FormMode.LOGIN
              ? Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                )
              : Text(
                  'Create account',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                )),
    );
  }

  Widget _showSecundaryButton() {
    return FlatButton(
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text(
              'Have an account? Sign in',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
            ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _showResetPSyButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FlatButton(
        onPressed: _sendResetPasswordEmail,
        child: _formMode == FormMode.LOGIN
            ? Text('Forgot Password?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
            : Container(
                height: 0,
                width: 0,
              ),
      ),
    );
  }

  Widget _showBody() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecundaryButton(),
              _showResetPSyButton(),
              _showErrorMessage()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      body: Stack(
        children: <Widget>[_showBody(), _showCircularSpinner()],
      ),
    );
  }
}
