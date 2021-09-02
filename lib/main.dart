import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
                controller: emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                controller: passwordController,
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  debugPrint(emailController.text);
                  debugPrint(passwordController.text);
                  login(context, passwordController.text, emailController.text);
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}

Future call(String password, String username) async {
  final response = await http.post('localhost:3000/users/login');

  print(response.body);
}

Future login(BuildContext context, String password, String username) async {
  var value = validateInputForLogin(password, username);
  if (value != "") {
    showToastMessage(value);
    return;
  }
  bool trustSelfSigned = true;
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  IOClient ioClient = new IOClient(httpClient);

  var url = "http://127.0.0.1:3000/users/login";
  Map data = {"email": username, "password": password};
  //encode Map to JSON
  var bodyNew = json.encode(data);

  http.Response response = await ioClient.post(url,
      headers: {"Content-Type": "application/json"},
      body: bodyNew); // post api call
  Map responseData = json.decode(response.body);
  print(response.body);
  showToastMessage("Login successful");
  navigateToHomePage(context, responseData);
}

navigateToHomePage(BuildContext context, Map responseData) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
}

showToastMessage(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}

String validateInputForLogin(String password, String username) {
  if (username.isEmpty) {
    return "Email is required";
  } else if (password.isEmpty) {
    return "Password is required";
  } else {
    return "";
  }
}
