// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_capstone_app/pages/home.dart';
import 'package:smart_home_capstone_app/pages/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String name = "";
  Future getDetails() async {
    http.Response response1 = await http.get(Uri.parse(
        "http://192.168.43.155/smarthome/name.php?email=${username.text}"));
    name = response1.body;
  }

  Future login() async {
    http.Response response = await http.get(Uri.parse(
        "http://192.168.43.155/smarthome/login.php?email=${username.text}&password=${password.text}"));
    getDetails();
    if (response.body == "Success") {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  username: username.text,
                )),
      );
    } else {
      // print('Login Unsuccessful');
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  void goRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(87, 65, 104, 1),
      body: ListView(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: const Color.fromRGBO(87, 65, 104, 0),
                    height: 750.0,
                    // width: double.infinity,
                  ),
                  Positioned(
                    top: 100.0,
                    right: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Color.fromRGBO(238, 238, 238, 1000),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 300.0,
                    left: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Color.fromRGBO(238, 238, 238, 1000),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150.0,
                    left: 50.0,
                    right: 50.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(56, 134, 151, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Home Design',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(238, 238, 238, 1),
                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: username,
                              // ignore: prefer_const_constructors
                              decoration: InputDecoration(
                                hintText: 'first.last@xyz.com',
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                ),
                                // border: InputBorder.none,
                                hintStyle: const TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                ),
                                // border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 100),
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'New User?',
                                style: TextStyle(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  goRegister();
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color.fromRGBO(247, 236, 89, 1),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(247, 236, 89, 1),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    )
                                  ]),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    login();
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
