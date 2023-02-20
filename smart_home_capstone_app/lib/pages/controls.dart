import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class Controls extends StatefulWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  String buttonText_OverheadLights = "Activate";
  bool isActive_OverheadLights = true;
  Future overHeadLightsOn() async {
    var response = await http.post(Uri.parse("http://192.168.103.61/StartAC"));
  }

  Future overHeadLightsOff() async {
    var response = await http.post(Uri.parse("http://192.168.103.61/StopAC"));
  }

  String buttonText_BathroomLights = "Activate";
  bool isActive_BathroomLights = false;

  String buttonText_BathroomTap = "Activate";
  bool isActive_BathroomTap = false;

  String buttonText_BedroomBlinds = "Activate";
  bool isActive_BedroomBlinds = false;

  String buttonText_BathroomBlinds = "Activate";
  bool isActive_BathroomBlinds = false;

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
                'Settings',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Color.fromRGBO(238, 238, 238, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                goSettings();
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
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
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
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        iconSize: 30.0,
                      ),
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
                    top: 50.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Overhead Lights',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
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
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_OverheadLights =
                                      !isActive_OverheadLights;
                                  setState(() {
                                    if (isActive_OverheadLights == true) {
                                      overHeadLightsOn();
                                      buttonText_OverheadLights = "Deactivate";
                                    } else {
                                      overHeadLightsOff();
                                      buttonText_OverheadLights = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_OverheadLights,
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
                  Positioned(
                    top: 150.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bathroom Lights',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
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
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BathroomLights =
                                      !isActive_BathroomLights;
                                  setState(() {
                                    if (isActive_BathroomLights == true) {
                                      buttonText_BathroomLights = "Deactivate";
                                    } else {
                                      buttonText_BathroomLights = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BathroomLights,
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
                  Positioned(
                    top: 250.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bathroom Tap',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 23,
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
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BathroomTap = !isActive_BathroomTap;
                                  setState(() {
                                    if (isActive_BathroomTap == true) {
                                      buttonText_BathroomTap = "Deactivate";
                                    } else {
                                      buttonText_BathroomTap = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BathroomTap,
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
                  Positioned(
                    top: 350.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bedroom Blinds',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
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
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BedroomBlinds =
                                      !isActive_BedroomBlinds;
                                  setState(() {
                                    if (isActive_BedroomBlinds == true) {
                                      buttonText_BedroomBlinds = "Deactivate";
                                    } else {
                                      buttonText_BedroomBlinds = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BedroomBlinds,
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
                  Positioned(
                    top: 450.0,
                    left: 30.0,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Bathroom Blinds',
                          style: TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1),
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
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
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  isActive_BathroomBlinds =
                                      !isActive_BathroomBlinds;
                                  setState(() {
                                    if (isActive_BathroomBlinds == true) {
                                      buttonText_BathroomBlinds = "Deactivate";
                                    } else {
                                      buttonText_BathroomBlinds = "Activate";
                                    }
                                  });
                                },
                                child: Text(
                                  buttonText_BathroomBlinds,
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
                  // controlTrigger('LED', 550, 40),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Widget controlTrigger(String device, double topVal, double leftVal) {
//   String buttonText = "Activate";
//   bool isActive = true;

//   return Positioned(
//     top: topVal,
//     left: leftVal,
//     child: Row(
//       // ignore: prefer_const_literals_to_create_immutables
//       children: [
//         Text(
//           device,
//           style: TextStyle(
//             color: Color.fromRGBO(238, 238, 238, 1),
//             fontFamily: 'Quicksand',
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 80),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: const Color.fromRGBO(247, 236, 89, 1),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: const Offset(0, 3),
//                   )
//                 ]),
//             child: Center(
//               child: TextButton(
//                 onPressed: () {
//                   isActive = !isActive;
//                   setState(() {
//                     // Put authentication function here
//                     isActive == true
//                         ? buttonText = "Deactivate"
//                         : buttonText = "Activate";
//                   });

//                   print(isActive);
//                 },
//                 child: Text(
//                   buttonText,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
