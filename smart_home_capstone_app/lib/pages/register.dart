// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_capstone_app/pages/home.dart';
import 'package:smart_home_capstone_app/pages/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();

  Future register() async {
    http.Response response = await http.get(Uri.parse(
        "http://192.168.43.155/smarthome/register.php?email=${username.text}&password=${password.text}&first_name=${firstname.text}&last_name=${lastname.text}"));
    if (response.body == "User Created Successfully") {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  void goLogin() {
    Navigator.pushReplacementNamed(context, '/login');
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
                    top: 100.0,
                    left: 50.0,
                    right: 50.0,
                    child: Container(
                      height: 580.0,
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
                              controller: firstname,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
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
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: lastname,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
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
                            height: 50,
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
                            height: 10,
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
                                  goLogin();
                                },
                                child: const Text(
                                  'Sign In',
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
                                    register();
                                  },
                                  child: const Text(
                                    'Sign Up',
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
