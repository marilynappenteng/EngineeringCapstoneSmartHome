import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValueBed = 'Bedroom 1';
  String dropdownValueControl = 'Blinds';

  void goHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void goReadPowerMeasurements() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void goSettings() {
    Navigator.pushReplacementNamed(context, '/settings');
  }

  void goHelp() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void goLogout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(56, 134, 151, 1),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Gerald Akita',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              accountEmail: const Text(
                'gerald_akita@yahoo.com',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: NetworkImage(
                        'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goHome();
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            ListTile(
              title: const Text(
                'Read Power Measurements',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goHome();
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            ListTile(
              title: const Text(
                'Help',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goHome();
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            ListTile(
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goLogout();
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromRGBO(87, 65, 104, 1),
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
                    top: 5,
                    left: 10,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState!.openDrawer(),
                        // onPressed: () {},
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        iconSize: 30.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50.0,
                    left: 40.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 100.0,
                    right: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: const Color.fromRGBO(238, 238, 238, 1000),
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
                        color: const Color.fromRGBO(238, 238, 238, 1000),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100.0,
                    left: 30.0,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      title: const Center(
                                        child: Text(
                                          'Add a room',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      content: Container(
                                        height: 200.0,
                                        width: 400.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          color: const Color.fromRGBO(
                                              238, 238, 238, 1000),
                                        ),
                                        child: Column(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  'Room Name',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const TextField(
                                              // controller: ,
                                              decoration: InputDecoration(
                                                hintText: 'Bedroom 1',
                                                // border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 80),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        87, 65, 104, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      )
                                                    ]),
                                                child: Center(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Done',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    )));
                          },
                          child: const Text(
                            'Add Room',
                            style: TextStyle(
                              color: Color.fromRGBO(238, 238, 238, 1),
                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150.0,
                    left: 30.0,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      title: const Center(
                                        child: Text(
                                          'Add a control',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      content: Container(
                                        height: 400.0,
                                        width: 400.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          color: const Color.fromRGBO(
                                              238, 238, 238, 1000),
                                        ),
                                        child: Column(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  'Room Name',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            DropdownButton<String>(
                                              value: dropdownValueBed,
                                              items: <String>[
                                                'Bedroom 1',
                                                'Bedroom 2',
                                                'Bedroom 3',
                                                'Bedroom 4'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                      fontFamily: 'Quicksand',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValueBed = newValue!;
                                                });
                                              },
                                            ),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  'Control Type',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            DropdownButton<String>(
                                              value: dropdownValueControl,
                                              items: <String>[
                                                'Blinds',
                                                'Windows',
                                                'Doors',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                      fontFamily: 'Quicksand',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValueControl =
                                                      newValue!;
                                                });
                                              },
                                            ),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  'Control Name',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const TextField(
                                              // controller: ,
                                              decoration: InputDecoration(
                                                hintText: 'Bedroom 1 Blinds',
                                                // border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 80),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        87, 65, 104, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      )
                                                    ]),
                                                child: Center(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Done',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    )));
                          },
                          child: const Text(
                            'Add Control',
                            style: TextStyle(
                              color: Color.fromRGBO(238, 238, 238, 1),
                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 200.0,
                    left: 30.0,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Manage Controls',
                            style: TextStyle(
                              color: Color.fromRGBO(238, 238, 238, 1),
                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 250.0,
                    left: 30.0,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      title: const Center(
                                        child: Text(
                                          'Manage Emergency Numbers',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      content: Container(
                                        height: 400.0,
                                        width: 400.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          color: const Color.fromRGBO(
                                              238, 238, 238, 1000),
                                        ),
                                        child: Column(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  '+233 20 000 0001',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  '+233 20 000 0002',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  '+233 20 000 0003',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  '+233 20 000 0004',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  '+233 20 000 0005',
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 80),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        87, 65, 104, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      )
                                                    ]),
                                                child: Center(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Done',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    )));
                          },
                          child: const Text(
                            'Manage Emergency Numbers',
                            style: TextStyle(
                              color: Color.fromRGBO(238, 238, 238, 1),
                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
